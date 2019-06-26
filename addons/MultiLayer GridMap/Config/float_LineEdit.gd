tool
extends LineEdit

func _on_text_changed(new_text : String):
	text = ""
	var has_float = false
	for c in new_text:
		if c == "0" || c.to_int() != 0:
			append_at_cursor(c)
		elif c == "." && !has_float:
			append_at_cursor(c)
			has_float = true
	
func _enter_tree():
	connect("text_changed", self, "_on_text_changed")
	
func get_value() -> float:
	return text.to_float()