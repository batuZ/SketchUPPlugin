require 'sketchup.rb'
require 'cm_test/func_1'
require 'socket' 
module CM_Test
    $g_s = TCPSocket.open('192.168.3.19', 21136)
# reload
  def self.reload
    original_verbose = $VERBOSE
    $VERBOSE = nil
    pattern = File.join(__dir__, '**/*.rb')
    Dir.glob(pattern).each { |file|
      load file
    }.size
    nil
  ensure
    $VERBOSE = original_verbose
    SKETCHUP_CONSOLE.clear
    puts 'cm_test reloaded!'
  end

# UI 
  unless file_loaded?(__FILE__)
    # 菜单栏
    tool_menu = UI.menu("Tools")      # Tools菜单栏
    tool_menu.add_separator           # 增加分隔线
    tool_menu.add_item("cm_test") {}

    # 工具栏（图标）
    tool_bar ||= UI::Toolbar.new('CityMaker Tools')

    # Button
    btn1 = UI::Command.new("Test") { 
      func_001 
    }
    btn1.tooltip = "启动自动同步"
    btn1.small_icon = "\\images\\connect.png"
    btn1.large_icon = "\\images\\connect.png"
    btn1.status_bar_text = "实时输出所有操作"
    btn1.menu_text = "start_syn"
    tool_bar.add_item btn1
    tool_bar.show
    
    @dialog = UI::HtmlDialog.new(
    {
      :dialog_title => "Log output",
      :preferences_key => "CM_Test",
      :scrollable => true,
      :resizable => true,
      :width => 600,
      :height => 100,
      :left => 100,
      :top => 100,
      :min_width => 50,
      :min_height => 50,
      :max_width =>1000,
      :max_height => 1000,
      :style => UI::HtmlDialog::STYLE_UTILITY
    })
    @dialog.bring_to_front
    @dialog.show

    file_loaded(__FILE__)
  end
end