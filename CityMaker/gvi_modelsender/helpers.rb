module GVI_Modelsender


	# entity 类型判断
	def self.isValidTaget? entityTag 
		isComponentTaget?(entityTag) or entityTag.typename.eql?'Face'
	end

	def self.isComponentTaget? entityTag
		entityTag.typename.eql?'Group' or entityTag.typename.eql?'ComponentInstance'
	end



	# 返回当前激活编辑区的路径
	# 内容依次为从model级到当前级的实例对象数组
	# 最后一个对象就是当前编辑区的编辑对象
	# 在model级时返回nil
	def self.parent_object
		Sketchup.active_model.active_path.last if Sketchup.active_model.active_path
	end




	# 全局发送
	# 1、通知server，清理root下所有内容
	# 2、从model级遍历子对象，并格式化每个entity的信息发送给server
	# 3、对group和组件递归
	# 4、只处理 group、组件、Face
	# 5、进度条？
	# GVI_Modelsender.globalUpdate
	def self.global_update 
		Sketchup.active_model.entities.each do |entity|
			formatEntity entity
		end
	end

	def self.formatEntity(entity)
		if entity.typename.eql?'Face' 
			sendMessage(Report_Edit.new(entity).to_report + data)

		elsif isComponentTaget? entity
			sendMessage(Report_Edit.new(entity).to_report)
			entity.definition.entities.each do |entity|
				formatEntity entity
			end
		end
	end



	# 报文格式化
	class Report
		def initialize(taget)
			@root_id 		= Sketchup.active_model.guid
			@offset 		= Sketchup.active_model.attribute_dictionary($opt)[$offset]
			@command		= 1 #c reate or edit
			@taget_id 	= taget.entityID
			@taget_type = taget.typename
			@parent_id 	= GVI_Modelsender.parent_object ? GVI_Modelsender.parent_object.entityID : Sketchup.active_model.guid
			@matrix44 	= Geom::Transformation.new.to_a
		end
		def to_report
			res = '{'
			self.instance_variables.each do |s|
				res += "#{s.to_s.gsub('@','')}:#{instance_variable_get s}" +","
			end
			res.chop+'}'
		end
	end

	class Report_Group < Report
		def initialize(taget)
			super taget
			@matrix44 	= taget.transformation.to_a
		end
	end

	class Report_Face < Report
		def initialize(taget)
			super taget
			# @osg SG_Formater.new(tag).data.size
			@textures
		end
	end

	class Report_Delete
		def initialize(taget_id)
			@root_id 		= Sketchup.active_model.guid
			@offset 		= Sketchup.active_model.attribute_dictionary($opt)[$offset]
			@command		= 2 # delete
			@taget_id 	= taget_id
		end
	end




	# sender
	def self.send_helper tag
		typeStr = tag.class.to_s
		if typeStr.eql? 'Sketchup::Face'
			osg, textures = OSG_Formater.new(tag).data
			sendMessage(Report_Edit.new(tag), OSG_Formater.new(tag).to_osg)

		elsif typeStr.eql? 'Fixnum'
			sendMessage(Report_Delete.new(tag).to_report)

		elsif typeStr.eql? 'Sketchup::Group' or typeStr.eql? 'Sketchup::ComponentInstance'
			sendMessage(Report_Group.new(tag).to_report)
		end
	end


	def self.sendMessage(report, data='')
		begin
			if Sketchup.active_model.attribute_dictionary($opt)[$isCon]
				header = [report.b.size, 0].pack("L*") # 8bit => 4*2 => reportSize, 0
				message = header + report + data
				TCPSocket.open(Sketchup.active_model.attribute_dictionary($opt)[$ip], $port).puts message
			end
		rescue Exception => e
			closeConnect
			UI.messagebox("error: #{e}")
		end
	end

# L* [1,2,3,4].pack("L*") # => 4bit(int32) * 4
# c# 接收示例
# while (true)
# {
# 	TcpClient client = await Task.Run(() => lisener.AcceptTcpClientAsync());
# 	NetworkStream clientStream = client.GetStream();
# 	try
# 	{
# 	    int size = 8;
# 	    byte[] buffer = new byte[size];
# 	    clientStream.Read(buffer, 0, size);
# 	    size = BitConverter.ToInt32(buffer, 0);
# 	    Console.WriteLine(size);

# 	    buffer = new byte[size];
# 	    clientStream.Read(buffer, 0, size);
# 	    string s = Encoding.UTF8.GetString(buffer);
# 	    Console.WriteLine(s);

# 	    clientStream.Close();
# 	    continue;
# 	}
# 	catch { }
# }


end