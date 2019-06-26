tool
extends Button

var config_menu : Control = null
var scroll_speed = 1

var dragging = false
var last_mouse_y = -1

func _ready():
	config_menu = get_node("../ConfigMenu")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")

func scroll(amount):
	config_menu.rect_position.y += amount

func _process(delta):
	if(dragging):
		var curr_mouse_y = get_global_mouse_position().y
		scroll((curr_mouse_y - last_mouse_y) * scroll_speed)
		last_mouse_y = curr_mouse_y

func _on_button_down():
	dragging = true
	last_mouse_y = get_global_mouse_position().y
	
func _on_button_up():
	dragging = false