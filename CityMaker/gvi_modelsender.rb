require 'sketchup.rb'
require 'extensions.rb'

module GVI_Modelsender
  #注册
  unless file_loaded?(__FILE__)
    ct = SketchupExtension.new('GVI_Modelsender', 'gvi_modelsender/main')
    ct.description  =  ' Synchronize data to CityMaker Connect '
    ct.version      =  ' 0.1.0 '
    ct.copyright    =  ' Copyright © 2015-2019 Gvitech Corporation. All rights reserved. '
    ct.creator      =  ' BT '
    Sketchup.register_extension(ct, true)
    file_loaded(__FILE__)
  end
end