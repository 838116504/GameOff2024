extends ColorRect

var current_view = null

@onready var map_item_view_panel_cntr = get_map_item_view_panel_cntr()
@onready var unit_view_vbox = get_unit_view_vbox()

func get_map_item_view_panel_cntr():
	return $scroll_cntr/vbox/map_item_view_panel_cntr

func get_unit_view_vbox():
	return $scroll_cntr/vbox/unit_view_vbox

func _ready():
	event_bus.listen(EventConst.SHOW_MAP_ITEM_DETAIL, _on_ent_show_map_item_detail)
	event_bus.listen(EventConst.HIDE_MAP_ITEM_DETAIL, _on_ent_hide_map_item_detail)

func _on_ent_show_map_item_detail(p_item):
	if current_view:
		current_view.hide()
		current_view = null
	
	if p_item is Unit:
		unit_view_vbox.unit = p_item
		current_view = unit_view_vbox
		current_view.show()
	else:
		map_item_view_panel_cntr.map_item = p_item
		current_view = map_item_view_panel_cntr
		current_view.show()
	
	show()

func _on_ent_hide_map_item_detail():
	hide()
