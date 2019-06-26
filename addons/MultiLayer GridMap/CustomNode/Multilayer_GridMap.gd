tool
extends Spatial

class_name MultiLayerGridMap

export(String, FILE, "*.mlgmc") var layer_config setget set_layer_config, get_layer_config

func set_layer_config(val):
	layer_config = val
	if(Engine.editor_hint):
		load_layer_config(val)

func get_layer_config():
	return layer_config

var layers : Array = []
var gridmaps : Array = []

export(Array) var Layers : Array = []
export(Array) var Layer_Visibility : Array = []
var LayerFileIO = preload("res://addons/MultiLayer GridMap/LayerFileIO.gd").new()

var save_timer : float = 0
const save_delay : float = 1.0

var rt = null

export var cell_size : Vector3 = Vector3(2, 2, 2) setget set_cell_size, get_cell_size
export var cell_scale : float = 1.0 setget set_cell_scale, get_cell_scale

func set_cell_size(val : Vector3):
	cell_size = val
	for g in gridmaps:
		g.cell_size = cell_size
func get_cell_size():
	return cell_size
	
func set_cell_scale(val : float):
	cell_scale = val
	for g in gridmaps:
		g.cell_scale = cell_scale
func get_cell_scale():
	return cell_scale

func select_layer(layer_idx):
	if (layer_idx < 0 || layer_idx >= gridmaps.size()):
		return
	var sel = EditorPlugin.new().get_editor_interface().get_selection()
	sel.clear()
	sel.add_node(gridmaps[layer_idx])

func _ready():
	var path = ""
	if(owner != null):
		path = owner.filename.replace(".tscn", ".mlgmap")
	if !(load_from_file(path)):
		print("Couldn't load file: " + path)
		load_layer_config(layer_config)

func load_layer_config(path):
	gridmaps = []
	layers = []
	var file : File = File.new()
	if !file.file_exists(layer_config):
		printerr("Config file not found!")
		return false
	
	file.open(layer_config, file.READ)
	if !file.is_open():
		printerr("Could not open config file!")
		return false
	
	var layer_count = file.get_32()
	for l in range(layer_count):
		layers.append(LayerFileIO.read_from_stream(file))
	
	for l in layers:		
		var curr = GridMap.new()
		gridmaps.append(curr)
		add_child(curr)
		if l.use_meshlib:
			var mlib = load(l.meshlib_path)
			curr.mesh_library = mlib
		else:
			curr.mesh_library = MeshLibrary.new()
		if l.use_as_properties:
			var mlib = curr.mesh_library
			for p in range(l.properties.size()):
				if mlib.get_last_unused_item_id() > p:
					mlib.set_item_name(p, mlib.get_item_name(p) + " - " + l.properties[p].name)
				else:
					mlib.create_item(p)
					var mesh = CubeMesh.new()
					mesh.material = SpatialMaterial.new()
					if l.properties[p].mesh_colour.a < 1:
						mesh.material.flags_transparent = true
					mesh.material.albedo_color = l.properties[p].mesh_colour
					mlib.set_item_mesh(p, mesh)
					mlib.set_item_shapes(p, [ BoxShape.new(), Transform.IDENTITY ])
					mlib.set_item_name(p, l.properties[p].name)
		if(!Engine.editor_hint && !l.visible_in_game):
			curr.visible = false
	return true

func _process(delta):
	if(Engine.editor_hint):
		save_timer += delta
		if(save_timer >= save_delay):
			save_timer -= save_delay
			save_to_file(get_tree().edited_scene_root.filename.replace(".tscn", ".mlgmap"))

func save_to_file(path):
	var file = File.new()
	file.open(path, file.WRITE)
	
	if(!file.is_open()):
		return false
	
	file.store_pascal_string(layer_config)
	
	file.store_16(gridmaps.size())
	for gm in gridmaps:
		var used_cells = gm.get_used_cells()
		file.store_16(used_cells.size())
		for uc in used_cells:
			file.store_float(uc.x)
			file.store_float(uc.y)
			file.store_float(uc.z)
			file.store_16(gm.get_cell_item(uc.x, uc.y, uc.z))
			file.store_16(gm.get_cell_item_orientation(uc.x, uc.y, uc.z))
	file.close()
	return true

func load_from_file(path):
	var file = File.new()
	file.open(path, file.READ)
	
	if(!file.is_open()):
		return false
	
	layer_config = file.get_pascal_string()
	if (!load_layer_config(layer_config)):
		return false
	var gridmap_count = file.get_16()
	for g in range(gridmap_count):
		var cell_count = file.get_16()
		print(cell_count)
		for c in range(cell_count):
			var coord = Vector3(file.get_float(), file.get_float(), file.get_float())
			var item = file.get_16()
			var orientation = file.get_16()
			gridmaps[g].set_cell_item(coord.x, coord.y, coord.z, item, orientation)
	file.close()
	return true

func get_tile(pos : Vector3):
	var res = { "pos": pos }
	for lI in range(layers.size()):
		var l = layers[lI]
		if(!l.use_as_properties):
			res[l.name] = gridmaps[lI].get_cell_item(pos.x, pos.y, pos.z)
		else:
			var item = gridmaps[lI].get_cell_item(pos.x, pos.y, pos.z)
			if(item >= 0):
				res[l.properties[item].name] = l.properties[item].value
			for p in range(l.properties.size()):
				if(p == item):
					continue
				res[l.properties[p].name] = null
	return res

func world_to_map(pos : Vector3):
	if (gridmaps.size() > 0):
		return gridmaps[0].world_to_map(pos)
	else:
		return null
func map_to_world(coord : Vector3):
	if (gridmaps.size() > 0):
		return gridmaps[0].map_to_world(coord)
	else:
		return null
