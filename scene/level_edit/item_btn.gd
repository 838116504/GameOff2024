extends TextureButton

var item : set = set_item

func get_center():
	return $center

func set_item(p_item:MapItem):
	assert(p_item != null)
	item = p_item
	var node = item.create_node()
	get_center().add_child(node)
