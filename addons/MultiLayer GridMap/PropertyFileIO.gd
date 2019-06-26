tool
extends Object

func read_from_stream(file : File) -> Property:
		var property = Property.new()
		property.name = file.get_pascal_string()
		property.mesh_colour = Color(file.get_float(), file.get_float(), file.get_float(), file.get_float())
		property.type = file.get_pascal_string()
		
		print("RTYPU: " + property.type + "   |   VAL: " + str(property.value))
		
		if property.type == "Bool":
			property.value = bool(file.get_8())
		elif property.type == "String":
			property.value = file.get_pascal_string()
		elif property.type == "Int":
			property.value = file.get_32()
		elif property.type == "Float":
			property.value = file.get_float()
		elif property.type == "Colour":
			property.value = Color(file.get_float(), file.get_float(), file.get_float(), file.get_float())
		elif property.type == "Vector2":
			property.value = Vector2(file.get_float(), file.get_float())
		elif property.type == "Vector3":
			property.value = Vector3(file.get_float(), file.get_float(), file.get_float())
		
		return property

func write_to_stream(file : File, property : Property):
	file.store_pascal_string(property.name)
	file.store_float(property.mesh_colour.r)
	file.store_float(property.mesh_colour.g)
	file.store_float(property.mesh_colour.b)
	file.store_float(property.mesh_colour.a)
	file.store_pascal_string(property.type)
		
	print("WTYPU: " + property.type + "   |   VAL: " + str(property.value))
	
	if property.type == "Bool":
		file.store_8(int(property.value))
	elif property.type == "String":
		file.store_pascal_string(property.value)
	elif property.type == "Int":
		file.store_32(property.value)
	elif property.type == "Float":
		file.store_float(property.value)
	elif property.type == "Colour":
		file.store_float(property.value.r)
		file.store_float(property.value.g)
		file.store_float(property.value.b)
		file.store_float(property.value.a)
	elif property.type == "Vector2":
		file.store_float(property.value.x)
		file.store_float(property.value.y)
	elif property.type == "Vector3":
		file.store_float(property.value.x)
		file.store_float(property.value.y)
		file.store_float(property.value.z)