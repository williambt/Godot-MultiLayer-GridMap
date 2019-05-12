tool
extends Object

var PropertyFileIO = preload("res://addons/MultiLayer GridMap/PropertyFileIO.gd").new()

func read_from_stream(file : File) -> Layer:
		var layer = Layer.new()
		layer.name = file.get_pascal_string()
		layer.visible_in_game = bool(file.get_8())
		layer.use_meshlib = bool(file.get_8())
		layer.meshlib_path = file.get_pascal_string()
		layer.use_as_properties = bool(file.get_8())
		var property_count = file.get_32()
		for p in range(property_count):
			layer.properties.append(PropertyFileIO.read_from_stream(file))
		
		return layer

func write_to_stream(file : File, layer : Layer):
	file.store_pascal_string(layer.name)
	file.store_8(int(layer.visible_in_game))
	file.store_8(int(layer.use_meshlib))
	file.store_pascal_string(layer.meshlib_path)
	file.store_8(int(layer.use_as_properties))
	
	file.store_32(layer.properties.size())
	for p in layer.properties:
		PropertyFileIO.write_to_stream(file, p)