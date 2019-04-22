require 'socket' 
require 'pp'

module GVI_Modelsender
	
	def self.logger obj1, obj2=nil
		pp caller[0].split(':').last + '-->'
		pp obj1
		pp obj2 if obj2
	end

	# windows一个app里只有一个model，so,windows里new or open model时，
	# 必须停止连接才能进行再连接，把新的guid\offset发给server
	# mac里一个app可以有多个models通过激活进行切换,

	class GVIAppObserver < Sketchup::AppObserver
		def onNewModel(model)
			GVI_Modelsender.logger model
			GVI_Modelsender.closeConnect if OS.empty? # empty is windows os
		end

		def onOpenModel(model)
			GVI_Modelsender.logger model
			GVI_Modelsender.closeConnect if OS.empty?
		end

		def onActivateModel(model)
		end

		def onQuit()
			GVI_Modelsender.logger 'onQuit'
			GVI_Modelsender.closeConnect
		end
	end

	class GVIModelObserver < Sketchup::ModelObserver
	  def onPlaceComponent(instance)
	   	GVI_Modelsender.logger instance
	  end

		# 当用户双击组件编辑时，显示他们遵循的模型层次结构中的“路径”。
		def onActivePathChanged(model)
			GVI_Modelsender.logger model
		end

		def onDeleteModel(model)
			GVI_Modelsender.logger model
		end

		# 当在模型中的任何被删除方法被调用
		def onEraseAll(model)
			GVI_Modelsender.logger model
		end

		def onExplode(model)
			GVI_Modelsender.logger model
		end

		def onTransactionCommit(model)
			GVI_Modelsender.logger model
		end
	end

	class GVIDefinitionsObserver < Sketchup::DefinitionsObserver
	  def onComponentAdded(definitions, definition)
	    GVI_Modelsender.logger definitions, definition
	  end
	  def onComponentPropertiesChanged(definitions, definition)
		  GVI_Modelsender.logger definitions, definition
		end

		def onComponentRemoved(definitions, definition)
		  GVI_Modelsender.logger definitions, definition
		end
		def onComponentTypeChanged(definitions, definition)
		  GVI_Modelsender.logger definitions, definition
		end
	end

	class GVIEntitiesObserver < Sketchup::EntitiesObserver

		def onElementAdded(entities, entity)
			GVI_Modelsender.logger entities, entity
		end

		def onElementModified(entities, entity)
			GVI_Modelsender.logger entities,entity
			# if(entity.is_a? Sketchup::AttributeDictionary)
			# 	log = entity.map{|k,v| "#{k}:#{v} <br>" }
			# 	$webdialog.set_html(log.to_s)
			# end
		end

		def onElementRemoved(entities, entity_id)
			GVI_Modelsender.logger entities, entity_id
		end

		def onEraseEntities(entities)
		  GVI_Modelsender.logger entities
		end
	end

	class GVIMaterialsObserver < Sketchup::MaterialsObserver
	  def onMaterialAdd(materials, material)
	    puts "onMaterialAdd: #{material}"
	  end
	  def onMaterialChange(materials, material)
		  puts "onMaterialChange: #{material}"
		end
		def onMaterialRefChange(materials, material)
		  puts "onMaterialRefChange: #{material}"
		end
		def onMaterialRemove(materials, material)
		  puts "onMaterialRemove: #{material}"
		end
		def onMaterialSetCurrent(materials, material)
		  puts "onMaterialSetCurrent: #{material}"
		end
	end

	class GVILayersObserver < Sketchup::LayersObserver
	  def onLayerAdded(layers, layer)
	    puts "onLayerAdded: #{layer.name}"
	  end
	  def onCurrentLayerChanged(layers, layer)
	    puts "onCurrentLayerChanged: #{layer.name}"
	  end
	  def onLayerChanged(layers, layer)
		  puts "onLayerChanged: #{layer.name}"
		end
		def onLayerRemoved(layers, layer)
		  puts "onLayerRemoved: #{layer.name}"
		end
		def onRemoveAllLayers(layers)
	    puts "onRemoveAllLayers: #{layers}"
	  end
	end

	class GVIViewObserver < Sketchup::ViewObserver
	  def onViewChanged(view)
	    GVI_Modelsender.sendMessage("cam:#{view.camera.eye.to_a + view.camera.target.to_a}")
	  end
	end

	class GVISelectionObserver < Sketchup::SelectionObserver
	  def onSelectionAdded(selection, entity)
		  # GVI_Modelsender.logger entity
		end
		# def ttt par
		# 	p par.guid
		# 	p s = Sketchup.active_model.find_entity_by_id(par.guid)
		# 	p s.persistent_id
		# end
		def onSelectionBulkChange(selection)
		  log = selection.map do |s| 
		  	if s.typename.eql?'Group' or s.typename.eql?'ComponentInstance'
		  		"#{s.typename}: #{s.guid} p --> #{s.parent.typename}: #{}</br>"
		  	elsif s.typename.eql? 'Face' or s.typename.eql? 'Edge'
		  	 	"#{s.typename}: #{s.persistent_id} p --> #{s.parent.typename}</br>"
		  	end
		  end
		  $webdialog.set_html(log.to_s)
		end
		def onSelectionCleared(selection)
		end
	end

end
