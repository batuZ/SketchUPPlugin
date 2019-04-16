require 'sketchup.rb'
require 'gvi_modelsender/settings'

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
    # tool_menu = UI.menu("Tools")
    # tool_menu.add_separator# 增加分隔线
    # tool_menu.add_item("DataSender"){ }

    # 工具栏（图标）
    tool_bar ||= UI::Toolbar.new('CityMaker Tools')

    # Button
    btn1 = UI::Command.new("DataSender"){ start_stop }
    btn1.tooltip            = "自动同步"                # => 鼠标悬停时显示折内容
    btn1.small_icon         = "\\images\\connect.png"  # => 小图标
    btn1.large_icon         = "\\images\\connect.png"  # => 大图标
    btn1.status_bar_text    = "自动同步"                 # => 状态栏显示的内容
    btn1.menu_text          = "自动同步"                    # => 按钮显示的内容
    tool_bar.add_item btn1

    tool_bar.show
    file_loaded(__FILE__)

    puts 'DataSender Ready'
  end
end