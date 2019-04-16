require 'sketchup.rb'
require 'gvi_modelsender/loger'


module GVI_Modelsender
	# reload
  def self.reload
    original_verbose = $VERBOSEK
    $VERBOSEK = nil
    pattern = File.join(__dir__, '**/*.rb')
    Dir.glob(pattern).each { |file|
      load file
    }.size
    nil
  ensure
    $VERBOSEK = original_verbose
    # @mod = Sketchup.active_model # Open model
    # @ent = mod.entities # All entities in model
    # @sel = mod.selection # Current selection
    SKETCHUP_CONSOLE.clear
    puts 'GVI_Modelsender reloaded!'
  end


  # UI 
  unless file_loaded?(__FILE__)
    # Tools菜单栏
    tool_menu = UI.menu("Tools")
    tool_menu.add_separator# 增加分隔线
    tool_menu.add_item("DataSender"){ }

    # 工具栏（图标）
    tool_bar ||= UI::Toolbar.new('CityMaker Tools')
   
    # Button
    btn1 = UI::Command.new("DataSender"){ alog 'DataSender Ready'}
    btn1.tooltip = "启动自动同步"
    btn1.small_icon = "\\images\\connect.png"
    btn1.large_icon = "\\images\\connect.png"
    btn1.status_bar_text = "实时输出所有操作"
    btn1.menu_text = "DataSender"
    tool_bar.add_item btn1
    tool_bar.show

    file_loaded(__FILE__)
    puts 'DataSender Ready'
  end
end