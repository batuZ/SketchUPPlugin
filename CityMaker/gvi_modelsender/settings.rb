require 'socket' 
require 'gvi_modelsender/observers'

module GVI_Modelsender
	$ip 						= nil
	$port 					= 21136
  $offset 				= []
  $isConnected 		= false

  Sketchup.add_observer(GVIAppObserver.new) 		
  $modelObs 			= GVIModelObserver.new
  # $definitionsObs	= GVIDefinitionsObserver.new
  # $entitiesObs 		= GVIEntitiesObserver.new
  # $materialsObs 	= GVIMaterialsObserver.new
  # $layersObs 			= GVILayersObserver.new
  # $viewObs 				= GVIViewObserver.new
  $selectionObs		= GVISelectionObserver.new

  def self.start_stop
    if $isConnected
    	closeConnect if UI.messagebox("[#{Sketchup.active_model.title}] 已经连联服务器，是否断开联接？", MB_YESNO) ==  IDYES
    else
    	showDialog
    end
  end

	def self.showDialog
		begin 
			config_file_name = __dir__ << '/settings.config'
			File.open(config_file_name,'w') do |file|
				file.puts '127.0.0.1'
				file.puts '0.0,0.0,0.0'
			end if not File.exists?config_file_name

			arr = IO.readlines(config_file_name)
			vec = arr[1].split(',')
			prompts = ["Connect主机IP：","偏移量 X：","偏移量 Y：","偏移量 Z："]
			defaults = [arr[0].strip, vec[0].to_f, vec[1].to_f, vec[2].to_f ]
			inputs = UI.inputbox(prompts, defaults, "设置")

			if inputs
				File.open(config_file_name,'w') do |file|
					file.puts inputs[0]
					file.puts "#{inputs[1]},#{inputs[2]},#{inputs[3]}"
				end

				$offset = Geom::Point3d.new(inputs[1].to_f,inputs[2].to_f,inputs[3].to_f)
				TCPSocket.open(inputs[0].strip, $port).puts "#{Sketchup.active_model.guid}:#{$offset.to_a}" + OS
				$ip = inputs[0].strip
				
				Sketchup.active_model.add_observer($modelObs) 									if $modelObs
				Sketchup.active_model.definitions.add_observer($definitionsObs) if $definitionsObs
        Sketchup.active_model.entities.add_observer($entitiesObs) 			if $entitiesObs
        Sketchup.active_model.materials.add_observer($materialsObs) 		if $materialsObs
        Sketchup.active_model.layers.add_observer($layersObs) 					if $layersObs
		  	Sketchup.active_model.active_view.add_observer($viewObs) 				if $viewObs
		  	Sketchup.active_model.selection.add_observer($selectionObs)			if $selectionObs
				$isConnected = true

		  	UI.messagebox("连接IP: #{inputs[0].strip} 成功")
    	end
  	rescue Exception => e
      UI.messagebox("连接主机IP失败，或输入坐标错误，请重试 #{e}")
      showDialog
    end
	end

	def self.closeConnect
		if $isConnected
			Sketchup.active_model.remove_observer($modelObs) 										if $modelObs
			Sketchup.active_model.definitions.remove_observer($definitionsObs) 	if $definitionsObs
	    Sketchup.active_model.entities.remove_observer($entitiesObs) 				if $entitiesObs
	    Sketchup.active_model.materials.remove_observer($materialsObs) 			if $materialsObs
	    Sketchup.active_model.layers.remove_observer($layersObs) 						if $layersObs
	  	Sketchup.active_model.active_view.remove_observer($viewObs) 				if $viewObs
			Sketchup.active_model.selection.remove_observer($selectionObs)			if $selectionObs
	 		$isConnected = false

	  	UI.messagebox("[#{Sketchup.active_model.title}] 已断开，自动同步停止!")
	  end
  end

	def self.sendMessage(message)
		begin
			TCPSocket.open($ip, $port).puts message+OS if $isConnected
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
end