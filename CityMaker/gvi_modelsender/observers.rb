require 'socket' 
require 'pp'

module GVI_Modelsender
	
	def self.logger obj1
		pp caller[0].split(':').last + '-->'
		pp obj1
	end

#-------- Model ----------------------------
# Sketchup.active_model

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

#-------- Entity ----------------------------
# Sketchup.active_model.entities[0]

	class MyEntityObserver < Sketchup::EntityObserver
		def onChangeEntity(entity)
		  puts "onChangeEntity: #{entity}"
		end
	  def onEraseEntity(entity)
	    puts "onEraseEntity: #{entity}"
	  end
	end

#-------- Entities ----------------------------
# Sketchup.active_model.entities

	class GVIEntitiesObserver < Sketchup::EntitiesObserver

		def onElementAdded(entities, entity)
			entity.add_observer(MyEntityObserver.new)
			GVI_Modelsender.logger  entity if not entity.typename.eql? 'Edge'
		end

		def onElementModified(entities, entity)
			GVI_Modelsender.logger entity if not entity.typename.eql? 'Edge'
			# if(entity.is_a? Sketchup::AttributeDictionary)
			# 	log = entity.map{|k,v| "#{k}:#{v} <br>" }
			# 	$webdialog.set_html(log.to_s)
			# end
		end

		def onElementRemoved(entities, entity_id)
			GVI_Modelsender.logger  entity_id
		end

		def onEraseEntities(entities)
		  GVI_Modelsender.logger entities
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
		  GVI_Modelsender.logger entity
		end

		def onSelectionBulkChange(selection)
			log = ''
			selection.each do |s|
				log += "<div>
				<p>self: #{s.typename}</p>
				<p>self_entityID: #{s.entityID}</p>
				<p>self_persistent_id: #{s.persistent_id}</p>
				<p>self_def_entID: #{(s.typename.eql?'Face' or s.typename.eql?'Edge') ? 'no definition' : s.definition.entityID} </p>
				<p>parent: #{s.parent.typename}</p> 
				<p>parent_entityID: #{(s.parent.typename.eql?'Model') ? s.parent.guid : s.parent.instances.first.entityID}</p>
				<p>parent_persistent_id: #{(s.parent.typename.eql?'Model') ? s.parent.guid : s.parent.instances.first.persistent_id}
				<p>parent_def_entID: #{s.parent.entityID}</p>
				</div>"
			end
		  $webdialog.set_html(log.to_s)
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
