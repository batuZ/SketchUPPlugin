require 'socket' 
module GVI_Modelsender

	# => 全局监视
	class GVIAppObserver < Sketchup::AppObserver
		def onNewModel(model)
			GVI_Modelsender.sendMessage 'onNewModel'
		end

		def onOpenModel(model)
			GVI_Modelsender.sendMessage 'onOpenModel'
		end

		def onQuit()
			GVI_Modelsender.sendMessage 'onQuit'
		end

		def onUnloadExtension(extension_name)
			puts "onUnloadExtension: #{extension_name}"
			if extension_name.eql?'GVI_Modelsender'
				Sketchup.remove_observer($appObs) if $appObs
  			Sketchup.active_model.active_view.remove_observer($viewObs) if $viewObs
				Sketchup.active_model.entities.remove_observer($entObs) if $entObs
			end
		end
	end

	class GVIViewObserver < Sketchup::ViewObserver
	  def onViewChanged(view)
	    GVI_Modelsender.sendMessage("cam:#{view.camera.eye.to_a + view.camera.target.to_a}")
	  end
	end

	class GVIEntitiesObserver < Sketchup::EntitiesObserver
		def onElementAdded(entities, entity)
			GVI_Modelsender.sendMessage 'onElementAdded'
		end

		def onElementModified(entities, entity)
			GVI_Modelsender.sendMessage 'onElementModified'
		end

		def onElementRemoved(entities, entity_id)
			GVI_Modelsender.sendMessage 'onElementRemoved'
		end
	end
end
# @mod = Sketchup.active_model 
# @ent = mod.entities 
# @sel = mod.selection 
# GVI_Modelsender.reload
# SKETCHUP_CONSOLE.clear