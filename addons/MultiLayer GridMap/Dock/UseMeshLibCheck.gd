tool
extends CheckBox

var mesh_lib_button : Button = null

func _enter_tree():
	mesh_lib_button = get_node("MeshLibButton")
	connect("pressed", self, "_on_check_toggled")
	
func _on_check_toggled():
	if is_pressed():
		enable_mesh_lib_button()
	else:
		disable_mesh_lib_button()
	
func enable_mesh_lib_button():
	mesh_lib_button.disabled = false
	mesh_lib_button.get_node("MeshLibLabel").add_color_override("font_color", Color.white)
	
func disable_mesh_lib_button():
	mesh_lib_button.disabled = true
	mesh_lib_button.get_node("MeshLibLabel").add_color_override("font_color", Color.darkgray)
