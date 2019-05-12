tool
extends EditorProperty

class_name LayerSelection

var updating = false
var btn = Button.new()

var pop = PopupMenu.new()

func _button_pressed():
	if(updating):
		return
		
	if (pop.visible):
		pop.hide()
	else:
		pop.clear()
		var arr = get_edited_object().layers
		for a in arr:
			if !(a is Layer):
				continue
			pop.add_item(a.name)
		pop.show()
		pop.rect_global_position = btn.rect_global_position + Vector2(0, btn.rect_size.y)
		pop.rect_size.x = btn.rect_size.x
		emit_changed(get_edited_property(), true)

func layer_selected(idx):
	get_edited_object().select_layer(idx)

func update_property():
	updating = true
	updating = false

func _init():
	add_child(btn)
	add_child(pop)
	btn.text = "Select Layers"
	btn.connect("button_up", self, "_button_pressed")
	pop.connect("id_pressed", self, "layer_selected")