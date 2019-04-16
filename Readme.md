# skechup 开发

## 工程结构 [参考](https://github.com/SketchUp/sketchup-ruby-api-tutorials/tree/master/examples/02_custom_tool)
    官方建议：
```
Sketchup:
    |- plugins:
    |   |- mytool.rb    // 注册文件
    |   |- mytool       // 与注册文件同名的文件夹，放具体实现
    |   |   |-  main.rb // 入口
    |   |   |-  tool.js
    |   |   |-  tool.rb
    |   |   |-  images  // 图像，按钮图标
    |   |   |   |-  img01.jpg 
    |   |   |   |-  img02.jpg
    |   |   |-  otherfiles
    |   |   |   |- ...
```

## 工程目录 [参考](https://github.com/SketchUp/sketchup-ruby-api-tutorials/wiki/Development-Setup#development-setup)
在Sketchup程序目录plugins里创建一个名为 `!external.rb` 的文件，内容为：
```ruby
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
```
    - sketchup的ruby API使用的是自带的ruby标准库，如果要使用rubygems,则要用系统中安装的ruby，当然，要用的gem也都安装在这里。
    - 这些gem只适合用来辅助开发，比如rspec\byebug\...，不能作为插件的一部份，其他人的电脑里可没有ruby
    - 加载这些gem，要先把系统ruby目录指给Sketchup
    - [参考](https://stackoverflow.com/questions/4982715/ruby-gems-in-google-sketchup)
```ruby
require 'rubygems' #=> error
$LOAD_PATH << "C:/Ruby186/lib/ruby/1.8"
$LOAD_PATH << "C:/Ruby186/lib/ruby/site_ruby/1.8"
$LOAD_PATH << "C:/Ruby186/lib/ruby/1.8/i386-mingw32"

$LOAD_PATH.uniq!

# print LOAD PATHS to console
Sketchup.send_action('showRubyPanel:')
  UI.start_timer(1,false) {
  puts "\nLOAD PATHS:\n"
  $LOAD_PATH.each {|x| puts "#{x}\n"}
  puts "\n\n"
}

require 'rubygems' #=> true
```

## 开发环境和IDE :VSCode
  - [VScode调试环境](https://github.com/SketchUp/sketchup-ruby-api-tutorials/wiki/VSCode-Debugger-Setup)
  - [VScode 自动补全](https://github.com/SketchUp/sketchup-ruby-api-tutorials/wiki/VSCode-Stubs-Setup)
  - [Sketchup Debug](https://github.com/SketchUp/sketchup-ruby-debugger)
  - 如果不对菜单，工具栏或类继承进行更改，则在大多数情况下可以重新加载扩展，而无需在每次更改之间重新启动SketchUp。
  - 使重新加载整个扩展更容易的一种方法是添加一个可以从Ruby控制台调用的小实用程序方法：
```ruby
# ~/Source/ExampleExtension/src/hello/debug.rb
module Example::HelloWorld

  # Reload extension by running this method from the Ruby Console:
  #   Example::HelloWorld.reload
  def self.reload
    original_verbose = $VERBOSE
    $VERBOSE = nil
    pattern = File.join(__dir__, '**/*.rb')
    Dir.glob(pattern).each { |file|
      # Cannot use `Sketchup.load` because its an alias for `Sketchup.require`.
      load file
    }.size
  ensure
    $VERBOSE = original_verbose
  end

end # module
```