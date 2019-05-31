require 'socket' 
require 'gvi_modelsender/helpers'

module GVI_Modelsender
	
#-------- Definitions ----------------------------

	class GVIDefinitionsObserver < Sketchup::DefinitionsObserver
	  def onComponentAdded(definitions, definition)
	    definition.entities.add_observer($entitiesObs) if $entitiesObs
	  end
	end

#-------- Entities ----------------------------

	class GVIEntitiesObserver < Sketchup::EntitiesObserver

		def onElementAdded(entities, entity)
			GVI_Modelsender.send_helper entity
			puts "Add[#{entity.typename}:#{entity.entityID}] in entities:[#{entities.count}]" if GVI_Modelsender.isValidTaget? entity if $DEBUG
		end

		def onElementModified(entities, entity)
			GVI_Modelsender.send_helper entity
			puts "Edit[#{entity.class}:#{entity.entityID}] in entities:[#{entities.count}]" if GVI_Modelsender.isValidTaget? entity if $DEBUG
		end

		def onElementRemoved(entities, entity_id)
			GVI_Modelsender.send_helper entity_id
			puts "Delete[#{entity_id}] in papa:[#{GVI_Modelsender.parent_object.typename if GVI_Modelsender.parent_object} : #{GVI_Modelsender.parent_object.entityID if GVI_Modelsender.parent_object}]" if $DEBUG
		end
	end

#-------- Selection ----------------------------

	class GVISelectionObserver < Sketchup::SelectionObserver
		def onSelectionBulkChange(selection)
			papa = GVI_Modelsender.parent_object
			log = ''
			selection.each do |s|
				log += "<div>
				<p>-------------- self -------------------------------</p>
				<p>self: #{s.typename}: #{s.entityID}</p>
				<p>-------------- papa -------------------------------</p>
				<p>parent: #{papa ? papa.typename : 'Model'}</p> 
				<p>parent_entityID: #{ papa ? papa.entityID : Sketchup.active_model.guid}</p>
				<p>parent_entities_count: #{papa ? papa.definition.entities.count : Sketchup.active_model.entities.count}</p>
				</div>"
			
				puts s.class.to_s
			end
		  $webdialog.set_html(log.to_s) if $webdialog
		  # puts Report.new(Sketchup.active_model,selection.first).to_report
		end

		def onSelectionCleared(selection)
			log =<<EOF
				<p>-------------- root.entities -------------------------------</p>
				<p>Model_guid: #{Sketchup.active_model.guid}</p>
				<p>Model_entities_count: #{Sketchup.active_model.entities.count}</p>

				<p>--------------- active_entities ------------------------------</p>
				<p>active_entities_path: Model: #{Sketchup.active_model.active_path.map{|s| "#{s.typename}:#{s.entityID}"} if Sketchup.active_model.active_path}</p>
				<p>active_entities_count: #{Sketchup.active_model.active_entities.count}</p>
EOF
			$webdialog.set_html(log.to_s) if $webdialog
		end
	end

#-------- App ----------------------------

	class GVIAppObserver < Sketchup::AppObserver
		def onNewModel(model)
			model.attribute_dictionary($opt,true)[$isCon] = false
		end

		def onOpenModel(model)
			model.attribute_dictionary($opt,true)[$isCon] = false
		end
	end
end
