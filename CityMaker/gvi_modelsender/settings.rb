require 'socket' 
require 'gvi_modelsender/observers'

module GVI_Modelsender
	$ip = nil
	$port = 21136
  $appObs = GVIAppObserver.new()
  # $viewObs = GVIViewObserver.new()
  $entObs = nil
  $offset = []
  def self.start_stop
    if $entObs.nil?
    	showDialog
    else
    	closeConnect if UI.messagebox("已经连接服务器，是否断开联接？", MB_YESNO) ==  IDYES
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
			defaults = [arr[0], vec[0].to_f, vec[1].to_f, vec[2].to_f ]
			inputs = UI.inputbox(prompts, defaults, "设置")

			if inputs
				File.open(config_file_name,'w') do |file|
					file.puts inputs[0]
					file.puts "#{inputs[1]},#{inputs[2]},#{inputs[3]}"
				end
				
				$offset = Geom::Point3d.new(inputs[1].to_f,inputs[2].to_f,inputs[3].to_f)
				TCPSocket.open(inputs[0].strip, $port).puts "#{Sketchup.active_model.guid}:#{$offset.to_a}" + OS
	
				$ip = inputs[0].strip

				$entObs = GVIEntitiesObserver.new()
        Sketchup.active_model.entities.add_observer($entObs)
				Sketchup.add_observer($appObs) if $appObs
		  	Sketchup.active_model.active_view.add_observer($viewObs) if $viewObs

		  	UI.messagebox("连接IP: #{inputs[0].strip} 成功")
    	end
  	rescue Exception => e
      UI.messagebox("连接主机IP失败，或输入坐标错误，请重试")
      showDialog
    end
	end

	def self.closeConnect
		Sketchup.remove_observer($appObs) if $appObs
  	Sketchup.active_model.active_view.remove_observer($viewObs) if $viewObs
		Sketchup.active_model.entities.remove_observer($entObs) if $viewObs
  	$entObs = nil
  	UI.messagebox("Connect 已断开，自动同步停止!")
  end

	def self.sendMessage(message)
		begin
			TCPSocket.open($ip, $port).puts message+OS if not $entObs.nil?
		rescue
			closeConnect
		end
	end
# @mod = Sketchup.active_model 
# @ent = mod.entities 
# @sel = mod.selection 
# GVI_Modelsender.reload
# SKETCHUP_CONSOLE.clear
end