tool
extends Control

var curr_input = null
var curr_type = ""

var int_LineEdit = preload("res://addons/MultiLayer GridMap/Dock/int_LineEdit.gd")
var float_LineEdit = preload("res://addons/MultiLayer GridMap/Dock/float_LineEdit.gd")
var Vector2Input = preload("res://addons/MultiLayer GridMap/Dock/Vector2Input.tscn")
var Vector3Input = preload("res://addons/MultiLayer GridMap/Dock/Vector3Input.tscn")

var _disabled : bool = false
var disabled setget _set_disabled, _get_disabled

func _get_disabled() -> bool:
	return _disabled
func _set_disabled(val : bool):
	_disabled = val
	if curr_input != null:
		if curr_type == "String" || curr_type == "Int" || curr_type == "Float":
			curr_input.editable = !_disabled
		else:
			curr_input.disabled = _disabled

func _enter_tree():
	var pt = get_node("../PropertyType")
	pt.connect("_on_PropertyType_changed", self, "set_property_type")
	set_property_type(pt.text)

func set_property_type(type : String):
	if(curr_input != null):
		pass
	curr_type = type
	if type == "Bool":
		if curr_input != null:
			curr_input.free()
		curr_input = CheckButton.new()
		add_child(curr_input)
	elif type == "Int":
		if curr_input != null:
			curr_input.free()
		curr_input = int_LineEdit.new()
		curr_input.rect_size = rect_size
		curr_input.anchor_right = 1
		add_child(curr_input)
	elif type == "Float":
		if curr_input != null:
			curr_input.free()
		curr_input = float_LineEdit.new()
		curr_input.rect_size = rect_size
		curr_input.anchor_right = 1
		add_child(curr_input)
	elif type == "String":
		if curr_input != null:
			curr_input.free()
		curr_input = LineEdit.new()
		curr_input.rect_size = rect_size
		curr_input.anchor_right = 1
		add_child(curr_input)
	elif type == "Colour":
		if curr_input != null:
			curr_input.free()
		curr_input = ColorPickerButton.new()
		curr_input.rect_size = rect_size
		curr_input.color = Color.white
		add_child(curr_input)
	elif type == "Vector2":
		if curr_input != null:
			curr_input.free()
		curr_input = Vector2Input.instance()
		curr_input.anchor_right = 1
		add_child(curr_input)
	elif type == "Vector3":
		if curr_input != null:
			curr_input.free()
		curr_input = Vector3Input.instance()
		curr_input.anchor_right = 1
		add_child(curr_input)
		
func get_property_value():
	if curr_type == "String":
		return curr_input.text
	elif curr_type == "Bool":
		return curr_input.is_pressed()
	elif curr_type == "Colour":
		return curr_input.color
		
	return curr_input.get_value()

func set_property_value(value):
	if curr_type == "Bool":
		if value is bool:
			curr_input.pressed = value
			return
		elif value == null:
			curr_input.pressed = false
			return
	elif curr_type == "Colour":
		if value is Color:
			curr_input.color = value
			return
		elif value == null:
			curr_input.color = Color.white
			return
	elif curr_type == "Vector2" || curr_type == "Vector3":
		if value is Vector2 || value is Vector3:
			curr_input.set_value(value)
			return
		elif value == null:
			if curr_type == "Vector2":
				curr_input.set_value(Vector2.ZERO)
				return
			else:
				curr_input.set_value(Vector3.ZERO)
				return
	elif curr_type == "String" || curr_type == "Int" || curr_type == "Float":
		if (value is String || value is int || value is float):
			curr_input.text = str(value)
			return
		elif value == null:
			if curr_type == "String":
				curr_input.text = ""
				return
			else:
				curr_input.text = "0"
				return
	
	printerr("Value not compatible with type: " + curr_type)