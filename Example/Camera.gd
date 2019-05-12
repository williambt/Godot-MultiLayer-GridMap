extends Camera

signal click_hit(hit)

func _input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		var space_state = get_world().direct_space_state
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000
		var res = space_state.intersect_ray(from, to)
		if (res):
			emit_signal("click_hit", res)