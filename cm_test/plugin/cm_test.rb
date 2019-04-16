require 'sketchup.rb'
require 'extensions.rb'

module CM_Test
  #注册
  unless file_loaded?(__FILE__)
    ct = SketchupExtension.new('CM_Test', 'cm_test/main')
    ct.description  =  '一个专门用来测试的 p'
    ct.version      =  ' 0.0.0 '
    ct.copyright    =  ' null '
    ct.creator      =  ' BT '
    Sketchup.register_extension(ct, true)
    file_loaded(__FILE__)
  end
end