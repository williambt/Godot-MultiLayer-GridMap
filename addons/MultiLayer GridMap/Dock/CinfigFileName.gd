tool
extends Control

var save_button : Button = null
var save_dialog : FileDialog = null
var load_button : Button = null
var load_dialog : FileDialog = null

signal save_path_selected(path)
signal load_path_selected(path)

func _enter_tree():
	save_button = get_node("SaveButton")
	load_button = get_node("LoadButton")
	save_dialog = get_node("SaveButton/SaveDialog")
	load_dialog = get_node("LoadButton/LoadDialog")

func _on_SaveButton_button_up():
	save_dialog.show()
	save_dialog.invalidate()
	save_dialog.rect_global_position = rect_global_position

func _on_LoadButton_button_up():
	load_dialog.show()
	load_dialog.invalidate()
	load_dialog.rect_global_position = rect_global_position

func _on_SaveDialog_file_selected(path):
	emit_signal("save_path_selected", path)

func _on_LoadDialog_file_selected(path):
	emit_signal("load_path_selected", path)
