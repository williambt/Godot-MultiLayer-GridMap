tool
extends Button

var original_width : float
var full_text : String = ""
export var file_dialog_path : NodePath
var file_dialog : FileDialog

func _enter_tree():
	original_width = rect_size.x
	file_dialog = get_node(file_dialog_path)
	connect("button_up", self, "_on_button_pressed")
	file_dialog.connect("file_selected", self, "_on_file_selected")
	
func _on_button_pressed():
	file_dialog.show()
	file_dialog.rect_global_position = rect_global_position
	
func _on_file_selected(path : String):
	set_txt(path)

func set_txt(txt):
	full_text = txt
	hint_tooltip = full_text
	text = txt
	
func set_current_file(path : String):
	set_txt(path)
	file_dialog.current_file = path
	
func get_file_path() -> String:
	return full_text

func _process(delta):
	if(rect_size.x > original_width):
		var dirs = text.split("/", false)
		if (dirs[0] == "res:" || dirs[0] ==  "..."):
			dirs.remove(0)
		if(dirs.size() > 1):
			dirs.remove(0)
		var new_text = "..."
		for d in dirs:
			new_text += "/" + d
		rect_size.x = original_width
		text = new_text

func _on_MeshLibButton_resized():
	original_width = rect_size.x
