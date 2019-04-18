require 'socket' 

module GVI_Modelsender
	
	def self.logger obj1, obj2=nil
		puts caller[0].split(':').last + '-->'
		puts "obj1"
		puts obj2 if obj2
	end

	class GVIAppObserver < Sketchup::AppObserver
		def onNewModel(model)
			GVI_Modelsender.logger model
		end

		def onOpenModel(model)
			GVI_Modelsender.logger model
		end

		def onQuit()
			GVI_Modelsender.logger 'onQuit'
		end

		def onUnloadExtension(extension_name)
			GVI_Modelsender.logger extension_name
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

	class GVIViewObserver < Sketchup::ViewObserver
	  def onViewChanged(view)
	    GVI_Modelsender.sendMessage("cam:#{view.camera.eye.to_a + view.camera.target.to_a}")
	  end
	end

	class GVIEntitiesObserver < Sketchup::EntitiesObserver
		def onElementAdded(entities, entity)
			GVI_Modelsender.logger entities, entity
		end

		def onElementModified(entities, entity)
			GVI_Modelsender.logger entities,entity
		end

		def onElementRemoved(entities, entity_id)
			GVI_Modelsender.logger entities, entity_id
		end
	end
end
