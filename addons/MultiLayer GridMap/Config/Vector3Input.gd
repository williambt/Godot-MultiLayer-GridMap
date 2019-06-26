tool
extends Control

var xLE : LineEdit = null
var yLE : LineEdit = null
var zLE : LineEdit = null

var _disabled : bool = false
var disabled setget _set_disabled, _get_disabled

func _set_disabled(val : bool):
	_disabled = val
	xLE.editable = !val
	yLE.editable = !val
	zLE.editable = !val
func _get_disabled() -> bool:
	return _disabled

func _enter_tree():
	xLE = get_node("X")
	yLE = get_node("Y")
	zLE = get_node("Z")
	
func get_value() -> Vector3:
	return Vector3(xLE.get_value(), yLE.get_value(), zLE.get_value())
	
func set_value(value : Vector3):
	xLE.text = str(value.x)
	yLE.text = str(value.y)
	zLE.text = str(value.z)