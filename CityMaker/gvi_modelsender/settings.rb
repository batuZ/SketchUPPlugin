require 'socket' 
require 'gvi_modelsender/observers'

module GVI_Modelsender
  $g_socket = nil
  $entObs = GVIViewObserver.new()

  # socket 是否已连接
  def self.is_socket_connected?
    return !$g_socket.nil? && !$g_socket.closed?
  end

  def self.connection ip
  	$g_socket = TCPSocket.open(ip.strip, 21136) # => 连不通会报错
  	Sketchup.active_model.active_view.add_observer($entObs)
  	UI.messagebox("连接IP: #{ip.strip} 成功")
  end

  def self.closeConnect
  	$g_socket.close
  	Sketchup.active_model.active_view.remove_observer($entObs)
  	UI.messagebox("已经断开联接！")
  end

  def self.start_stop
    if is_socket_connected?
    	closeConnect
    else
    	showDialog
    end
  end

  # 打开设置对话框
	def self.showDialog
		if not is_socket_connected?
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
					connection inputs[0].strip
	    	end
	  	rescue Exception => e
	      UI.messagebox("连接主机IP失败，或输入坐标错误，请重试")
	      showDialog
	    end
	  else
	  	if UI.messagebox("已经连接服务器，是否断开联接？", MB_YESNO) ==  IDYES
	  		 closeConnect
	  	end
	  end
	end
end