extends RefCounted
class_name EventConst

const DIALOGUE = &"dialogue"
const SHOW_MAP_ITEM_DETAIL = &"show_map_item_detail"
const HIDE_MAP_ITEM_DETAIL = &"hide_map_item_detail"

const INFO_LIST = [
	[ DIALOGUE, [ {"name":"id", "type":TYPE_INT} ]],
	[ SHOW_MAP_ITEM_DETAIL, [ {"name":"item", "type":TYPE_OBJECT} ]],
	[ HIDE_MAP_ITEM_DETAIL, [ ]],
]
