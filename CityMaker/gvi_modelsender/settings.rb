require 'socket' 
require 'gvi_modelsender/observers'
require 'pp'

module GVI_Modelsender
	$port 	= 21136
	$ip 		= :ip
	$offset = :offset
	$opt 		= 'GVI_Modelsender_options'
	$isCon 	= :isConnected

  Sketchup.add_observer(GVIAppObserver.new)
  # $modelObs 			= GVIModelObserver.new
  $definitionsObs	= GVIDefinitionsObserver.new
  $entitiesObs 		= GVIEntitiesObserver.new
  # $materialsObs 	= GVIMaterialsObserver.new
  # $layersObs 			= GVILayersObserver.new
  # $viewObs 				= GVIViewObserver.new
  $selectionObs		= GVISelectionObserver.new

  def self.start_stop
    if Sketchup.active_model.attribute_dictionary($opt,true)[$isCon]
    	closeConnect if UI.messagebox("[#{Sketchup.active_model.title}] 已经连联服务器，是否断开联接？", MB_YESNO) ==  IDYES
    else
    	showDialog
    end
  end

	def self.showDialog
		begin 
			opts = Sketchup.active_model.attribute_dictionary($opt)
			opts[$ip]			||= '127.0.0.1'
			opts[$offset]	||= Geom::Point3d.new
			opts[$isCon] 	||= false

			prompts = ["Connect主机IP：","偏移量 X：","偏移量 Y：","偏移量 Z："]
			defaults = [opts[$ip], opts[$offset].x, opts[$offset].y, opts[$offset].z ]
			inputs = UI.inputbox(prompts, defaults, "设置")

			if inputs
				opts[$ip] = inputs[0].strip
				opts[$offset] = Geom::Point3d.new(inputs[1].to_f,inputs[2].to_f,inputs[3].to_f)
				TCPSocket.new(inputs[0].strip, $port).puts "#{Sketchup.active_model.guid}:#{opts[$offset].to_a}" + OS
			
				10.times{removeObservers} 
				addObservers

		  	UI.messagebox("[#{Sketchup.active_model.title}] 连接IP: #{inputs[0].strip} 成功！")
    	end
  	rescue Exception => e
      UI.messagebox("连接主机IP失败，或输入坐标错误，请重试 #{e}")
      showDialog
    end
	end

	def self.closeConnect
		if Sketchup.active_model.attribute_dictionary($opt)[$isCon]
			10.times{removeObservers}  
	  	UI.messagebox("[#{Sketchup.active_model.title}] 已断开，自动同步停止!")
	  end
  end
  def self.addObservers
  		Sketchup.active_model.add_observer($modelObs) 									if $modelObs
			Sketchup.active_model.definitions.add_observer($definitionsObs) if $definitionsObs
      Sketchup.active_model.entities.add_observer($entitiesObs) 			if $entitiesObs
      Sketchup.active_model.materials.add_observer($materialsObs) 		if $materialsObs
      Sketchup.active_model.layers.add_observer($layersObs) 					if $layersObs
	  	Sketchup.active_model.active_view.add_observer($viewObs) 				if $viewObs
	  	Sketchup.active_model.selection.add_observer($selectionObs)			if $selectionObs
	  	Sketchup.active_model.attribute_dictionary('GVI_Modelsender_options',true)['isConnected'] = true
  end

  def self.removeObservers
  	Sketchup.active_model.remove_observer($modelObs)										if $modelObs
		Sketchup.active_model.definitions.remove_observer($definitionsObs)	if $definitionsObs
    Sketchup.active_model.entities.remove_observer($entitiesObs) 				if $entitiesObs
    Sketchup.active_model.materials.remove_observer($materialsObs) 			if $materialsObs
    Sketchup.active_model.layers.remove_observer($layersObs) 						if $layersObs
  	Sketchup.active_model.active_view.remove_observer($viewObs) 				if $viewObs
		Sketchup.active_model.selection.remove_observer($selectionObs)			if $selectionObs
 		Sketchup.active_model.attribute_dictionary('GVI_Modelsender_options',true)['isConnected'] = false
  end

	def self.sendMessage(message)
		begin
			TCPSocket.open($ip, $port).puts message+OS if Sketchup.active_model.attribute_dictionary($opt)[$isCon]
		rescue Exception => e
			closeConnect
			UI.messagebox("error: #{e}")
		end
	end
# @mod = Sketchup.active_model.find_entity_by_persistent_id
# @ent = mod.entities 
# @sel = mod.selection 
# GVI_Modelsender.reload
# SKETCHUP_CONSOLE.clear
# Sketchup::Edge:0x007fa018b3bbd0>
end