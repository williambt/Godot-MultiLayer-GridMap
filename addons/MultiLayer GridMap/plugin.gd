tool
extends EditorPlugin

var inspector
var dock

func _enter_tree():
	inspector = preload("res://addons/MultiLayer GridMap/CustomNode/InspectorPlugin.gd").new()
	dock = preload("res://addons/MultiLayer GridMap/Dock/Dock.tscn").instance()
	add_custom_type("MultiLayer GridMap", "Spatial", preload("res://addons/MultiLayer GridMap/CustomNode/Multilayer_GridMap.gd"), preload("res://addons/MultiLayer GridMap/CustomNode/icon.png"))
	#add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	get_editor_interface().get_editor_viewport().add_child(dock)
	add_inspector_plugin(inspector)
	
	make_visible(true)

func _exit_tree():
	remove_inspector_plugin(inspector)
	dock.queue_free()
	#remove_control_from_docks(dock)
	remove_custom_type("MultiLayer GridMap")

func has_main_screen():
	return true

func make_visible(visible):
	pass

func get_plugin_name():
	return "Layer Config"

func get_plugin_icon():
	return preload("res://addons/MultiLayer GridMap/CustomNode/icon.png")