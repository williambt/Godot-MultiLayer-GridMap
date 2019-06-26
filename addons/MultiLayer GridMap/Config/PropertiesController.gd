tool
extends Control

var properties : Array

var property_list : ItemList = null

var property_name : LineEdit = null

var mesh_colour_picker : ColorPickerButton = null
var property_type : Button = null
var property_value : Control = null

var previous_selected : int = -1

func get_properties() -> Array:
	return properties.duplicate()

func set_properties(new_properties : Array):
	store_previous_property_data()
	clear_properties()
	for p in new_properties:
		add_property(p)
	select_property(0)

func _ready():
	property_list = get_node("PropertyList")
	
	property_name = get_node("PropertyName")
	
	mesh_colour_picker = get_node("MeshColour")
	property_type = get_node("PropertyType")
	property_value = get_node("PropertyValue")
	
#Set dock settings to received property
func set_property_dock(property : Property):
	property_name.text = property.name
	mesh_colour_picker.color = property.mesh_colour
	property_type.set_type(property.type)
	property_value.set_property_value(property.value)
	
func clear_properties():
	previous_selected = -1
	properties.clear()
	property_list.clear()

#Store property data from dock on property with received index
func store_property_data(idx : int):
	if idx < 0 || idx >= properties.size():
		return
	var property = properties[idx]
	property.name = property_name.text
	property.mesh_colour = mesh_colour_picker.color
	property.type = property_type.text
	property.value = property_value.get_property_value()

#Stores property data from dock on previously selected property
func store_previous_property_data():
	store_property_data(previous_selected)

func dock_to_default():
	property_name.text = ""
	mesh_colour_picker.color = Color.white
	property_type.reset_type()
	property_value.set_property_value(null)

#Creates new empty property
func new_property():
	properties.append(Property.new())
	property_list.add_item("<Unnamed>")
	select_property(property_list.get_item_count()-1)

#Create new property with settings from received property
func add_property(property : Property):
	properties.append(property)
	if property.name == "":
		property_list.add_item("<Unnamed>")
	else:
		property_list.add_item(property.name)

#Select property from index
func select_property(idx : int):
	store_previous_property_data()
	if idx >= 0 && property_list.get_item_count() > idx:
		property_list.select(idx)
		set_property_dock(properties[idx])
		previous_selected = idx
		toggle_input_enabled(true)
	else:
		deselect_property()

func deselect_property():
	store_previous_property_data()
	property_list.unselect_all()
	toggle_input_enabled(false)
	dock_to_default()

#Remove property from index
func remove_property(idx : int):
	if idx < 0 || properties.size() < idx:
		return
	
	properties.remove(idx)
	property_list.remove_item(idx)
	
	previous_selected = -1
	
	var new_size = properties.size()
	if new_size > 0:
		if idx < new_size:
			select_property(idx)
		else:
			select_property(idx-1)
	else:
		deselect_property()

func remove_selected_property():
	remove_property(get_selected_property_index())

#Returns the index of currently selected property or -1 if none
func get_selected_property_index() -> int:
	var sel_properties = property_list.get_selected_items()
	if sel_properties.size() == 0:
		return -1
	else:
		return sel_properties[0]

#Returns currently selected property or null if none
func get_selected_property() -> Property:
	var sel_property_idx = get_selected_property_index()
	if sel_property_idx < 0:
		return null
	else:
		return properties[sel_property_idx]

#Returns property name from LineEdit, by default changes empty strings to "<Unnamed>"
func get_property_name(include_empty : bool = false):
	if include_empty:
		return property_name.text
	else:
		if property_name.text == "":
			return "<Unnamed>"
		else:
			return property_name.text

func toggle_input_enabled(enabled):
	property_name.editable = enabled
	mesh_colour_picker.disabled = !enabled
	property_type.disabled = !enabled
	property_value.disabled = !enabled

#Signals

func _on_PropertyList_item_selected(index):
	select_property(index)

func _on_PropertyName_text_changed(new_text):
	var sel_idx = get_selected_property_index()
	if sel_idx >= 0:
		properties[sel_idx].name = new_text
		property_list.set_item_text(sel_idx, get_property_name())

