tool
extends LineEdit

func _on_text_changed(new_text : String):
	text = ""
	for c in new_text:
		if c == "0" || c.to_int() != 0:
			append_at_cursor(c)
	
func _enter_tree():
	connect("text_changed", self, "_on_text_changed")
	
func get_value() -> int:
	return text.to_int()