tool
extends Control

var xLE : LineEdit = null
var yLE : LineEdit = null

var _disabled : bool = false
var disabled setget _set_disabled, _get_disabled

func _set_disabled(val : bool):
	_disabled = val
	xLE.editable = !val
	yLE.editable = !val
func _get_disabled() -> bool:
	return _disabled

func _enter_tree():
	xLE = get_node("X")
	yLE = get_node("Y")
	
func get_value() -> Vector2:
	return Vector2(xLE.get_value(), yLE.get_value())

func set_value(value : Vector2):
	xLE.text = str(value.x)
	yLE.text = str(value.y)