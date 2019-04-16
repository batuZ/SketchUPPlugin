require 'sketchup.rb'

module CM_Test
	def self.func_001
		@mod = Sketchup.active_model
		@ent = @mod.entities
	end
end