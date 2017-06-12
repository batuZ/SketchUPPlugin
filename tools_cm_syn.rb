require 'socket'
require 'tmpdir'
require "tools_cm_syn\\tools_cm_class.rb" 

$IP = "127.0.0.1"
$Prot = 22215
$PYL =  Geom::Point3d.new
$CDir = Dir.tmpdir
$texList = Array.new
$isStartUP = true
Sketchup.add_observer(MyAppObserver.new())  # 全局监视
$viewObs = MyViewObserver.new()				# 视图监控实例
$entObs  = MyEntitiesObserver.new()			# 模型监控实例
#====================================
tool_menu = UI.menu("Tools")				# Tools菜单栏
tool_menu.add_separator						# 增加分隔线
tool_menu.add_item("启动自动同步") {startUP()}
tool_menu.add_item("停止自动同步") {shutDonw()}
#=====================================
toolbar = UI::Toolbar.new "CityMaker Connect 同步工具"
start = UI::Command.new("Start"){startUP()}
stop = UI::Command.new("Stop") {shutDonw()}
onec = UI::Command.new("Onec") {$entObs.upDataSelection()}
#-----------------
start.tooltip = "启动自动同步"
start.small_icon = "\\tools_cm_syn\\images\\connect.png"
start.large_icon = "\\tools_cm_syn\\images\\connect.png"
start.status_bar_text = "实时输出所有操作"
start.menu_text = "start_syn"
toolbar = toolbar.add_item start
#-----------------
stop.tooltip = "停止自动同步"
stop.small_icon = "\\tools_cm_syn\\images\\unconnect.png"
stop.large_icon = "\\tools_cm_syn\\images\\unconnect.png"
stop.status_bar_text = "停止输出并清除输出记录"
stop.menu_text = "Stop_syn"
toolbar = toolbar.add_item stop
#------------------
onec.tooltip = "同步选中对象"
onec.small_icon = "\\tools_cm_syn\\images\\updata.png"
onec.large_icon = "\\tools_cm_syn\\images\\updata.png"
onec.status_bar_text = "更新选中的对象"
onec.menu_text = "Stop_syn"
toolbar = toolbar.add_item onec
toolbar.show