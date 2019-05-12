tool
extends EditorInspectorPlugin

func can_handle(object):
	return object is MultiLayerGridMap

func parse_property(object, type, path, hint, hint_text, usage):
	if (path == "Layers"):
		add_property_editor(path, LayerSelection.new())
		return
	elif (path == "Layer_Visibility"):
		add_property_editor(path, LayerVisibility.new())
	else:
		return false