# Console 可以用来查看加载错误:
SKETCHUP_CONSOLE.show
# 工程目录
paths = [ '/Users/Batu/MyData/su_sdk/plugin' ]
paths.each { |path|
  $LOAD_PATH << path
  Dir.glob("#{path}/*.{rb,rbs,rbe}") { |file|
    Sketchup.require(file)
  }
}