extends Spatial

var mlgm : MultiLayerGridMap = null

func _ready():
	mlgm = get_node("MultiLayer GridMap")
	print(mlgm.gridmaps.size())

func _on_Camera_click_hit(hit):
	var is_mlgm_child = false
	if (hit.collider is GridMap):
		for c in range(mlgm.get_child_count()):
			if (hit.collider == mlgm.get_child(c)):
				is_mlgm_child = true
				break
	if (is_mlgm_child):
		var tile = mlgm.get_tile(hit.collider.world_to_map(hit.position - Vector3(0, 0.01, 0)))
		print("Red: " + str(tile["red"]))
