def startUP
    if $isStartUP
        begin 
            prompts = ["Connect主机IP：","偏移量 X：","偏移量 Y：","偏移量 Z："]
            defaults = [$IP,$PYL.x,$PYL.y,$PYL.z]
            inputs = UI.inputbox(prompts, defaults, "输入Connect主机IP及偏移量")
            if inputs.kind_of?Array
                $PYL = Geom::Point3d.new(inputs[1].to_f,inputs[2].to_f,inputs[3].to_f)
                $IP = inputs[0]
                TCPSocket.new($IP,$Prot).puts "pyl:#{$PYL.to_a}"
                Sketchup.active_model.active_view.add_observer($viewObs)
                Sketchup.active_model.entities.add_observer($entObs)
                $isStartUP = false
                # => 设置纹理共享目录
                if ($IP != '127.0.0.1' )
                    temp = "\\\\#{$IP}\\"
                else
                    temp = Dir.tmpdir
                end
                temp = UI.select_directory(title: "选择Connect同步目录", directory: "#{temp}")
                if temp
                   $CDir = temp
                end
                UI.messagebox("自动同步已启动！")
            end
        rescue
            UI.messagebox("连接失败,请重新确认Connect主机IP")
            startUP()
        end
    end
end

def shutDonw
    if not $isStartUP
        Sketchup.active_model.active_view.remove_observer($viewObs)
        Sketchup.active_model.entities.remove_observer($entObs)
        $isStartUP = true
        UI.messagebox("自动同步停止!")
    end
end

def sendMessage(message)
    begin
        if not $isStartUP
           tcp = TCPSocket.new($IP,$Prot)
           tcp.puts message
           tcp.close
        end
    rescue
        Sketchup.active_model.active_view.remove_observer($viewObs)
        Sketchup.active_model.entities.remove_observer($entObs)
        $isStartUP = true
        UI.messagebox("Connect 已断开，自动同步停止!")
    end
end

# => 全局监视
class MyAppObserver < Sketchup::AppObserver
    def onNewModel(model)
        if not $isStartUP
            sendMessage("del:ALLENT")
            $isStartUP = true
        end
    end
    def onOpenModel(model)
        if not $isStartUP
            sendMessage("del:ALLENT")
            $isStartUP = true
        end
    end
    def onQuit()
        if not $isStartUP
            sendMessage("del:ALLENT")
            $isStartUP = true
        end
    end
end

# => 相机同步类
class MyViewObserver < Sketchup::ViewObserver
    def onViewChanged(view)
        msg = "cam:#{view.camera.eye.to_a + view.camera.target.to_a}"
        sendMessage(msg)
    end
end

# => 数据同步类
class MyEntitiesObserver < Sketchup::EntitiesObserver
    @@modelName = ""

    def onElementAdded(entities, entity)
       sendRenderModelPointInfo(entity)
    end

    def onElementModified(entities, entity)
       sendRenderModelPointInfo(entity)
    end

    def onElementRemoved(entities, entity_id)
        puts msg = "del:#{entity_id}"
        sendMessage(msg)
    end

    # => 过滤传入的实体，执行对应的操作
    def sendRenderModelPointInfo(h)
        @@modelName = "#{h.entityID}"
        trans = Geom::Transformation.new
        if(h.class == Sketchup::Face)
            upDataFace(h,trans)
            sendMessage("modelPoint:#{h.entityID}")
        elsif(h.class == Sketchup::Group or h.class == Sketchup::ComponentInstance)
            h.definition.entities.each{|g| explodeEnt(g, h.transformation)}
            sendMessage("modelPoint:#{h.entityID}")
        end
    end

    # => 递归组或组件
    def explodeEnt(d, trans)
        if(d.class == Sketchup::Face)
            upDataFace(d,trans)
        elsif(d.class == Sketchup::Group or d.class == Sketchup::ComponentInstance)
            topTrans = trans * d.transformation
            d.definition.entities.each{|g| explodeEnt(g, topTrans)}
        end
    end

    # => 更新实体
    def upDataFace(s,trans)        
        faceMsg = "DrawGroup:#{s.entityID}:#{@@modelName}"
         # => —————— 模型
        pointsArray = Array.new
        uvArray = Array.new
        uvhlp = s.get_UVHelper
        s.mesh.points.each{|p| 
            transP = p.transform(trans)
            pointsArray = pointsArray + transP.to_a
            uvp = uvhlp.get_front_UVQ(p)
            uvArray = uvArray + uvp.to_a
        }
        pointsMsg = "poi:#{pointsArray}"
        uvMsg = "uv:#{uvArray}"

        idArray = Array.new
        s.mesh.polygons.each{|f| idArray = idArray + f.to_a}
        indexMsg = "id:#{idArray}"

        # => —————— 材质
        mat = s.material ? s.material : s.back_material
        if not mat.nil?
            color = mat.color
            color.alpha = mat.alpha
            
            if mat.materialType != 0 
                materialPath = mat.texture.filename                             # => 原生纹理路径：1、程序库只有名，2、引用文件有全路径
                texName = File.basename(materialPath).gsub(' ','_') 
                if not($texList.include?texName)
                    shareMap(s)
                end
                textureMsg = "tex:#{texName};#{uvMsg}"
            end
            materialMsg = "col:#{color.to_a};#{textureMsg};"
        end #if
        faceMsg = "DrawGroup:#{s.entityID}:#{@@modelName}"
        msg = "#{faceMsg};#{pointsMsg};#{indexMsg};#{materialMsg}"
        sendMessage(msg)
    end #def

    # => 共享纹理
    def shareMap(s)
        mat = s.material ? s.material : s.back_material
        materialPath = mat.texture.filename                  # => 原生纹理路径：1、程序库只有名，2、引用文件有全路径
        texName = File.basename(materialPath).gsub(' ','_')         # => 获得纹理名称
        targetPath = File.join($CDir,texName)                       # => 目标纹理文件 
        if not(File.exist?targetPath)                               # => 不存在时,执行以下操作，存在则全部跳过
            if(File.exist?materialPath)                             # => materialPath 为引用文件则直接copy到目标位置
                FileUtils.cp(materialPath,$CDir)
            else                                                    # => materialPath 为程序库纹理时，把纹理定到目标位置
                _width = mat.texture.image_width
                _height = mat.texture.image_height
                texSize = _height > _width ? _width : _height
                mat.write_thumbnail(targetPath, texSize-1)   # => 写出文件
            end
             $texList << texName
             sleep 1
        end
    end #def

 # => 更新选中-----------------------------------------------------------------------
    def upDataSelection()
        if not $isStartUP
            selected = Sketchup.active_model.selection
            if selected.count == 0
                if UI.messagebox('未选择任何物体，即将把场景中全部内容发送到connect，这需要一些时间，确定这么做吗？', MB_YESNO) == IDYES
                    modName = File.exist?(Sketchup.active_model.path) ? File.basename(Sketchup.active_model.path) : 'temp.skp'
                    filename = File.join($CDir, modName)
                    if(Sketchup.active_model.save(filename))
                        msg = "file:#{modName}"
                        tcp = TCPSocket.new($IP,$Prot)
                        tcp.puts msg
                        tcp.close 
                    end
                end
            else
                selected.each{|h| 
                @@modelName = "#{h.entityID}"
                trans = Geom::Transformation.new
                if(h.class == Sketchup::Face)
                    upDataFace1(h,trans)
                    TCPSocket.new($IP,$Prot).puts "modelPoint:#{h.entityID}"
                elsif(h.class == Sketchup::Group or h.class == Sketchup::ComponentInstance)
                    h.make_unique
                    h.definition.entities.each{|g| explodeEnt1(g, h.transformation)}
                    TCPSocket.new($IP,$Prot).puts "modelPoint:#{h.entityID}"
                end
                }
            end
        end
    end

    def explodeEnt1(d, trans)
        if(d.class == Sketchup::Face)
            upDataFace1(d,trans)
        elsif(d.class == Sketchup::Group or d.class == Sketchup::ComponentInstance)
            d.make_unique
            topTrans = trans * d.transformation
            d.definition.entities.each{|g| explodeEnt1(g, topTrans)}
        end
    end

    # => 更新实体
    def upDataFace1(s,trans)
        begin
            faceMsg = "DrawGroup:#{s.entityID}:#{@@modelName}"
            # => —————— 模型
            pointsArray = Array.new
            uvArray = Array.new
            uvhlp = s.get_UVHelper
            s.mesh.points.each{|p| 
                transP = p.transform(trans)
                pointsArray = pointsArray + transP.to_a
                uvp = uvhlp.get_front_UVQ(p)
                uvArray = uvArray + uvp.to_a
            }
            pointsMsg = "poi:#{pointsArray}"
            uvMsg = "uv:#{uvArray}"

            idArray = Array.new
            s.mesh.polygons.each{|f| idArray = idArray + f.to_a}
            indexMsg = "id:#{idArray}"

            # => —————— 材质
            mat = s.material ? s.material : s.back_material
            if not mat.nil?
                color = mat.color
                color.alpha = mat.alpha
                
                if mat.materialType != 0 
                    materialPath = mat.texture.filename                             # => 原生纹理路径：1、程序库只有名，2、引用文件有全路径
                    texName = File.basename(materialPath).gsub(' ','_') 
                    if not($texList.include?texName)
                        # => ------------------------------------
                        targetPath = File.join($CDir,texName)                       # => 目标纹理文件 
                        if not(File.exist?targetPath)                               # => 不存在时,执行以下操作，存在则全部跳过
                            if(File.exist?materialPath)                             # => materialPath 为引用文件则直接copy到目标位置
                                FileUtils.cp(materialPath,$CDir)
                            else                                                    # => materialPath 为程序库纹理时，把纹理定到目标位置
                                _width = mat.texture.image_width
                                _height = mat.texture.image_height
                                texSize = _height > _width ? _width : _height
                                mat.write_thumbnail(targetPath, texSize-1)   # => 写出文件
                            end
                            $texList << texName
                        end
                        # => ------------------------------------
                    end
                    textureMsg = "tex:#{texName};#{uvMsg}"
                end
                materialMsg = "col:#{color.to_a};#{textureMsg};"
            end #if
            
            msg = "#{faceMsg};#{pointsMsg};#{indexMsg};#{materialMsg}"
            TCPSocket.new($IP,$Prot).puts msg
        rescue
        end
    end #def
    # => ----------------------------------------------------------------------------------------
end #class
# => SKETCHUP_CONSOLE.clear

