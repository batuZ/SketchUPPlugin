module GVI_Modelsender
	def self.alog msg
		puts msg
	end
	
	def self.error msg
		UI.messagebox(msg)
	end
end