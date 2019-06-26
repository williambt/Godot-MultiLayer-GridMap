tool
extends Control

var LayerFileIO = preload("res://addons/MultiLayer GridMap/LayerFileIO.gd").new()

var layers : Array = []

var layer_list : ItemList = null
var layer_name : LineEdit = null

var visibility_check : CheckBox = null
var use_meshlib_check : CheckBox = null
var meshlib_button : Button = null
var use_as_properties_check : CheckBox = null

var previous_selected = -1

var properties : Control = null

func _ready():
	layer_list = get_node("LayerList")
	
	layer_name = get_node("LayerName")
	
	visibility_check = get_node("VisibilityCheck")
	use_meshlib_check = get_node("UseMeshLibCheck")
	meshlib_button = get_node("UseMeshLibCheck/MeshLibButton")
	use_as_properties_check = get_node("UseAsPropertiesCheck")
	
	properties = get_node("Properties")
	
	toggle_input_enabled(false)

func load_from_file(path : String):
	var file = File.new()
	file.open(path, file.READ)
	if !file.is_open():
		printerr("Couldn't open file")
		return
	
	clear_layers()
	
	var layer_count = file.get_32()
	for l in range(layer_count):
		add_layer(LayerFileIO.read_from_stream(file))

func save_to_file(path : String):
	var file = File.new()
	file.open(path, file.WRITE)
	if !file.is_open():
		printerr("Couldn't open file")
		return
		
	store_layer_data()
	properties.store_previous_property_data()
	
	file.store_32(layers.size())
	for l in layers:
		LayerFileIO.write_to_stream(file, l)

#Set dock settings to received layer
func set_layer_dock(layer : Layer):
	layer_name.text = layer.name
	visibility_check.pressed = layer.visible_in_game
	use_meshlib_check.pressed = layer.use_meshlib
	use_meshlib_check.emit_signal("pressed")
	if layer.meshlib_path != "":
		meshlib_button.set_current_file(layer.meshlib_path)
	else:
		meshlib_button.set_current_file("")
		meshlib_button.text = "Click to choose file"
	use_as_properties_check.pressed = layer.use_as_properties
	properties.set_properties(layer.properties.duplicate())

#Stores layer data from dock on selected layer
func store_layer_data():
	var sel_idx = previous_selected
	if sel_idx < 0:
		return
	var layer = layers[sel_idx]
	layer.name = layer_name.text
	layer.visible_in_game = visibility_check.pressed
	layer.use_meshlib = use_meshlib_check.pressed
	layer.meshlib_path = meshlib_button.get_file_path()
	layer.use_as_properties = use_as_properties_check.pressed
	layer.properties = properties.get_properties()
	
func dock_to_default():
	layer_name.text = ""
	visibility_check.pressed = false
	use_meshlib_check.pressed = false
	use_meshlib_check._on_check_toggled()
	meshlib_button.text = "Click to choose file"
	use_as_properties_check.pressed = false
	_on_UseAsPropertiesCheck_pressed()

#Creates new empty layer
func new_layer():
	layers.append(Layer.new())
	layer_list.add_item("<Unnamed>")
	select_layer(layer_list.get_item_count()-1)

#Create new layer with settings from received layer
func add_layer(layer : Layer):
	layers.append(layer)
	if layer.name == "":
		layer_list.add_item("<Unnamed>")
	else:
		layer_list.add_item(layer.name)

#Select layer from index
func select_layer(idx : int):
	store_layer_data()
	if idx >= 0 && layer_list.get_item_count() > idx:
		layer_list.select(idx)
		set_layer_dock(layers[idx])
		previous_selected = idx
		toggle_input_enabled(true)
	else:
		deselect_layer()
	_on_UseAsPropertiesCheck_pressed()

func deselect_layer():
	store_layer_data()
	layer_list.unselect_all()
	toggle_input_enabled(false)
	dock_to_default()

#Remove layer from index
func remove_layer(idx : int):
	print(idx)
	if idx < 0 || layers.size() < idx:
		return
	
	layers.remove(idx)
	layer_list.remove_item(idx)
	
	previous_selected = -1
	
	var new_size = layers.size()
	if new_size > 0:
		if idx < new_size:
			select_layer(idx)
		else:
			print(idx-1)
			select_layer(idx-1)
	else:
		deselect_layer()
			
func remove_selected_layer():
	remove_layer(get_selected_layer_index())
	
func clear_layers():
	previous_selected = -1
	layers.clear()
	layer_list.clear()
	toggle_input_enabled(false)

#Returns the index of currently selected layer or -1 if none
func get_selected_layer_index() -> int:
	var sel_layers = layer_list.get_selected_items()
	if sel_layers.size() == 0:
		return -1
	else:
		return sel_layers[0]

#Returns currently selected layer or null if none
func get_selected_layer() -> Layer:
	var sel_layer_idx = get_selected_layer_index()
	if sel_layer_idx < 0:
		return null
	else:
		return layers[sel_layer_idx]

#Returns layer name from LineEdit, by default changes empty strings to "<Unnamed>"
func get_layer_name(include_empty : bool = false):
	if include_empty:
		return layer_name.text
	else:
		if layer_name.text == "":
			return "<Unnamed>"
		else:
			return layer_name.text

func toggle_input_enabled(enable : bool):
	layer_name.editable = enable
	visibility_check.disabled = !enable
	use_meshlib_check.disabled = !enable
	use_as_properties_check.disabled = !enable

#Signals

func _on_LayerList_item_selected(index):
	select_layer(index)

func _on_LayerName_text_changed(new_text):
	var sel_idx = get_selected_layer_index()
	if sel_idx >= 0:
		layers[sel_idx].name = new_text
		layer_list.set_item_text(sel_idx, get_layer_name())

func _on_UseAsPropertiesCheck_pressed():
	if use_as_properties_check.pressed:
		properties.visible = true
	else:
		properties.visible = false