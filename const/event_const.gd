extends RefCounted
class_name EventConst

const DIALOGUE = &"dialogue"
const SHOW_MAP_ITEM_DETAIL = &"show_map_item_detail"
const HIDE_MAP_ITEM_DETAIL = &"hide_map_item_detail"
const SHOW_ENEMY_PANEL = &"show_enemy_panel"
const SHOW_DATABASE_PANEL = &"show_database_panel"
const FIGHT = &"fight"
const GAMEOVER = &"gameover"
const SHOW_PLAYER_PANEL = &"show_player_panel"

const ENABLE_BLUR = &"enable_blur"
const DISABLE_BLUR = &"disable_blur"

const INFO_LIST = [
	[ DIALOGUE, [ {"name":"id", "type":TYPE_INT} ]],
	[ SHOW_MAP_ITEM_DETAIL, [ {"name":"item", "type":TYPE_OBJECT} ]],
	[ HIDE_MAP_ITEM_DETAIL, [ ]],
	[ SHOW_ENEMY_PANEL, [ {"name":"unit", "type":TYPE_OBJECT} ]],
	[ FIGHT, [ {"name":"unit", "type":TYPE_OBJECT} ]],
	[ GAMEOVER, [ ]],
	[ SHOW_PLAYER_PANEL, [ {"name":"player_unit", "type":TYPE_OBJECT} ]],
	[ SHOW_DATABASE_PANEL, [ {"name":"database", "type":TYPE_OBJECT} ]],
	
	[ ENABLE_BLUR, [ ]],
	[ DISABLE_BLUR, [ ]],
]
