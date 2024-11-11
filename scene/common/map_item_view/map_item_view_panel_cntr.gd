extends PanelContainer

var map_item:MapItem : set = set_map_item

func get_icon_tex_rect():
	return $vbox/hbox/icon_tex_rect

func get_name_label():
	return $vbox/hbox/name_label

func get_desc_label():
	return $vbox/desc_label


func set_map_item(p_item):
	map_item = p_item
	update()

func update():
	if map_item == null:
		return
	
	var iconTexRect = get_icon_tex_rect()
	iconTexRect.texture = map_item.get_icon()
	var nameLabel = get_name_label()
	nameLabel.text = map_item.get_map_item_name()
	var descLabel = get_desc_label()
	descLabel.text = map_item.get_description()
