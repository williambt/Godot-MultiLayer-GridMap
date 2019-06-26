tool
extends Button

signal _on_PropertyType_changed(new_type)

export var menu_path : NodePath
var menu : PopupMenu

var default_type : String = ""

func _enter_tree():
	menu = get_node(menu_path)
	menu.connect("id_pressed", self, "_on_TypeMenu_id_pressed")
	for mi in range(menu.get_item_count()):
		if(menu.is_item_checked(mi)):
			text = menu.get_item_text(mi)
	default_type = text

func set_type(type : String):
	var item_count = menu.get_item_count()
	var idx = -1
	for i in range(item_count):
		if menu.get_item_text(i) == type:
			idx = i
			break
	if idx >= 0:
		for i in range(menu.get_item_count()):
			menu.set_item_checked(i, false)
		menu.set_item_checked(idx, true)
		text = type

		emit_signal("_on_PropertyType_changed", type)

func reset_type():
	set_type(default_type)

func _on_PropertyType_button_down():
	menu.rect_position = rect_global_position
	menu.show()
	
func _on_TypeMenu_id_pressed(idx):
	for i in range(menu.get_item_count()):
		menu.set_item_checked(i, false)
	
	menu.set_item_checked(idx, true)
	text = menu.get_item_text(idx)
	
	emit_signal("_on_PropertyType_changed", text)