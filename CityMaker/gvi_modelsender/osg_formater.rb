require 'json'

p2d = Struct.new(:x, :y)
p3d = Struct.new(:x, :y, :z)
p4d = Struct.new(:a, :b, :c, :d)

class Material

end

class StateSet
	def initialize
    # @UniqueID = 'StateSet_2'
    # @name = "01 - Default"
    # @rendering_hint = 'DEFAULT_BIN'
    # @renderBinMode = 'INHERIT'
    # @GL_CULL_FACE = 'ON'
    # @GL_LIGHTING = 'ON'
    # @GL_BLEND = 'OFF'
    # @GL_NORMALIZE = 'ON'
    # @Material = {}
    # @CullFace = {}
    # @textureUnit 0 = {
    #   GL_TEXTURE_2D ON
    #   Texture2D {}
    # }
   	# @textureUnit 1 = {
    #   GL_TEXTURE_2D ON
    #   Texture2D {}
    # }
	end
end

class Geometry
	def initialize
		# @DataVariance 	= 'STATIC'
		# @StateSet 			= {}
		# @useDisplayList = 'TRUE'
		# @useVertexBufferObjects = 'FALSE'
		# @PrimitiveSets	= {}
		# @VertexArray		= {}
		# @NormalBinding = 'PER_VERTEX'
		# @NormalArray		={}
		# @TexCoordArray = {}
	end
end

class Node
	@@index = -1
	def initialize
		@UniqueID 			= "#{self.class}_#{@@index += 1}"
		@DataVariance 	= 'STATIC'
		@name           = nil
		@nodeMask				= '0xffffffff'
		@cullingActive	= 'TRUE'
		@referenceFrame = 'RELATIVE'
    @childrens			= []
	end

	def to_osg
		ihash = {}
		ihash[:UniqueID] 			= @UniqueID 			if  @UniqueID
		ihash[:DataVariance] 	= @DataVariance 	if  @DataVariance
		ihash[:name] 					= @name 					if  @name
		ihash[:nodeMask] 			= @nodeMask 			if  @nodeMask
		ihash[:cullingActive] = @cullingActive 	if  @cullingActive
		ihash[:referenceFrame] = @referenceFrame 	if  @referenceFrame
		ihash[child_field_name] = @childrens.size
		ihash[self.class.to_sym] = @childrens   if  @childrens.size > 0
		self.class.to_s + ihash.to_json#.gsub('"','').gsub(':',' ').gsub(',',"\r\n").gsub('{',"{\r\n").gsub('}',"\r\n}")
	end

	def child_field_name
		self.class.to_s == 'Geode' ? :num_drawables : :num_children
	end
	attr_accessor :UniqueID, :DataVariance, :name, :nodeMask, :cullingActive, :referenceFrame, :childrens
end

# -----------------------------------------------

class Geode < Node
end

class MatrixTransform < Node
	def initialize
		super
		@Matrix = [
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,0,1
		]
	end

	def to_osg
		ihash = {}
		ihash[:UniqueID] 			= @UniqueID 			if  @UniqueID
		ihash[:DataVariance] 	= @DataVariance 	if  @DataVariance
		ihash[:name] 					= @name 					if  @name
		ihash[:nodeMask] 			= @nodeMask 			if  @nodeMask
		ihash[:cullingActive] = @cullingActive 	if  @cullingActive
		ihash[:referenceFrame] 	= @referenceFrame 	if  @referenceFrame
		ihash[:Matrix]					= @Matrix
		ihash[child_field_name] = @childrens.size if  @childrens.size > 0
		ihash[self.class.to_sym] = @childrens   	if  @childrens.size > 0
		self.class.to_s + ihash.to_json#.gsub('"','').gsub(':',' ').gsub(',',"\r\n").gsub('{',"{\r\n").gsub('}',"\r\n}")
	end
end

class Group < Node
end

# -----------------------------------------------
class Root
	def initialize
		@groups = [Group.new]
	end
	def to_osg(*a)
		groups.map do |g|
			g.to_osg
		end
	end
	attr_accessor :groups
end

# -----------------------------------------------
# r = MatrixTransform.new

# puts r.instance_variables
# puts r.to_osg
# g = Group.new
# puts g.to_osg
# aFile = File.new("1.txt","w")
#        aFile.puts r.to_osg
# aFile.close

