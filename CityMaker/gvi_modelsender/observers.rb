require 'socket' 
require 'pp'
require 'gvi_modelsender/helpers'

module GVI_Modelsender
	
	def self.logger objs, obj=nil

	end

#-------- Model ----------------------------
# Sketchup.active_model

	class GVIModelObserver < Sketchup::ModelObserver

		# def onActivePathChanged(model)
		# 	#当用户打开用于编辑位置的实例时，打开的实例中的实体的变换将相对于全局世界坐标而不是相对于其父节点的本地坐标。
		# end

	 #  def onPlaceComponent(instance)
	 #   	GVI_Modelsender.logger instance
	 #  end

		# def onDeleteModel(model)
		# 	GVI_Modelsender.logger model
		# end

		# # 当在模型中的任何被删除方法被调用
		# def onEraseAll(model)
		# 	GVI_Modelsender.logger model
		# end

		# def onExplode(model)
		# 	GVI_Modelsender.logger model
		# end

		# def onTransactionCommit(model)
		# 	GVI_Modelsender.logger model
		# end
	end

#-------- Definition ----------------------------
# Sketchup.active_model.definitions[0]
	
	class MyDefObserver < Sketchup::DefinitionObserver
	  def onComponentInstanceAdded(definition, instance)
	    puts "onComponentInstanceAdded(#{definition}, #{instance})"
	  end
	  def onComponentInstanceRemoved(definition, instance)
		  puts "onComponentInstanceRemoved(#{definition}, #{instance})"
		end
	end

#-------- Definitions ----------------------------
# Sketchup.active_model.definitions

	class GVIDefinitionsObserver < Sketchup::DefinitionsObserver
	  def onComponentAdded(definitions, definition)
	  	definition.add_observer(MyDefObserver.new)
	    GVI_Modelsender.logger  definition
	  end
	  def onComponentPropertiesChanged(definitions, definition)
		  GVI_Modelsender.logger  definition
		end

		def onComponentRemoved(definitions, definition)
		  GVI_Modelsender.logger  definition
		end
		def onComponentTypeChanged(definitions, definition)
		  GVI_Modelsender.logger  definition
		end
	end


#-------- Entities ----------------------------
# Sketchup.active_model.entities

	class GVIEntitiesObserver < Sketchup::EntitiesObserver

		def onElementAdded(entities, entity)
			puts "Add[#{entity.typename}:#{entity.entityID}] in [#{entities.count}]" if not entity.typename.eql? 'Edge'
		end

		def onElementModified(entities, entity)
			puts "Edit[#{entity.typename}:#{entity.entityID}] in [#{entities.count}]" if not entity.typename.eql? 'Edge'
		end

		def onElementRemoved(entities, entity_id)
			puts "Delete[#{entity_id}] in [#{entities.count}]"
		end
	end

#-------- Materials ----------------------------
# Sketchup.active_model.materials

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

#-------- Layers ----------------------------
# Sketchup.active_model.layers

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

#-------- View ----------------------------
# Sketchup.active_model.active_view

	class GVIViewObserver < Sketchup::ViewObserver
	  def onViewChanged(view)
	    GVI_Modelsender.sendMessage("cam:#{view.camera.eye.to_a + view.camera.target.to_a}")
	  end
	end

#-------- Selection ----------------------------
# Sketchup.active_model.selection

	class GVISelectionObserver < Sketchup::SelectionObserver
	  def onSelectionAdded(selection, entity)
		  # GVI_Modelsender.logger entity
		end

		def onSelectionBulkChange(selection)
			papa = GVI_Modelsender.parent_object
			log = ''
			selection.each do |s|
				log += "<div>
				<p>self: #{s.typename}</p>
				<p>self_entityID: #{s.entityID}</p>
				<p>self_def_entID: #{(s.typename.eql?'Face' or s.typename.eql?'Edge') ? 'no definition' : s.definition.entityID} </p>
				<p>parent: #{papa ? papa.typename : 'Model'}</p> 
				<p>parent_entityID: #{ papa ? papa.entityID : Sketchup.active_model.guid}</p>
				<p>parent_def_entID: #{papa ? papa.definition.entityID : Sketchup.active_model.guid}</p>

				</div>"
			end
		  $webdialog.set_html(log.to_s)
		  # puts Report.new(Sketchup.active_model,selection.first).to_report
		end

		def onSelectionCleared(selection)
			log =<<EOF
				<p>entities: #{Sketchup.active_model.entities.count}</p>
				<p>definitions: #{Sketchup.active_model.definitions.count}</p>
				<p>layers: #{Sketchup.active_model.layers.count}</p>
				<p>materials: #{Sketchup.active_model.materials.count}</p>
EOF
			$webdialog.set_html(log.to_s)
		end
	end

#-------- App ----------------------------

	class GVIAppObserver < Sketchup::AppObserver
		def onNewModel(model)
			GVI_Modelsender.logger model
			model.attribute_dictionary($opt,true)[$isCon] = false
		end

		def onOpenModel(model)
			GVI_Modelsender.logger model
			model.attribute_dictionary($opt,true)[$isCon] = false
		end
	end
end
