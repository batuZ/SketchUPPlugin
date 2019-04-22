require 'sketchup.rb'
require 'gvi_modelsender/settings'

module GVI_Modelsender

  # reload
  def self.reload
    closeConnect
    original_verbose = $VERBOSEK
    $VERBOSEK = nil
    pattern = File.join(__dir__, '**/*.rb')
    Dir.glob(pattern).each { |file|
      load file
    }.size
    nil
  ensure
    $VERBOSEK = original_verbose
    SKETCHUP_CONSOLE.clear
    puts 'GVI_Modelsender reloaded!'
  end

  # 根据当前操作系统填加结束符
  OS ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          ""
      when /darwin|mac os/
          "\r\n"
      when /linux/
          "\r\n"
      when /solaris|bsd/
          "\r\n"
      else
          raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
    end
    )

  # UI 
  unless file_loaded?(__FILE__)
    # Tools菜单栏
    tool_menu = UI.menu("Tools")
    tool_menu.add_separator# 增加分隔线
    tool_menu.add_item("DataSender"){ start_stop }

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
    # reload btn
    btn_test = UI::Command.new("DataSender"){ GVI_Modelsender.reload }
    tool_bar.add_item btn_test
    btn1.tooltip            = "重新加载插件"  

    tool_bar.show

    $webdialog = UI::HtmlDialog.new(
    {
      :dialog_title => "Log output",
      # :preferences_key => "CM_Test",
      :scrollable => true,
      :resizable => true,
      :width => 500,
      :height => 100,
      :left => 950,
      :top => 780,
      :min_width => 50,
      :min_height => 50,
      :max_width =>1000,
      :max_height => 1000,
      # :style => UI::HtmlDialog::STYLE_UTILITY
    })
    $webdialog.bring_to_front
    $webdialog.show
    

    file_loaded(__FILE__)

    puts 'DataSender Ready'
  end
end