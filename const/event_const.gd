extends RefCounted
class_name EventConst

const SHOW_DIALOGUE = &"show_dialogue"
const HIDE_DIALOGUE = &"hide_dialogue"
const SHOW_HELP_POPUP = &"show_help_popup"
const HIDE_HELP_POPUP = &"hide_help_popup"

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
	[ SHOW_DIALOGUE, [ {"name":"id", "type":TYPE_INT} ]],
	[ HIDE_DIALOGUE, [ ]],
	[ SHOW_HELP_POPUP, [ ]],
	[ HIDE_HELP_POPUP, [ ]],
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
