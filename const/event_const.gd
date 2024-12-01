extends RefCounted
class_name EventConst

const SHOW_DIALOGUE = &"show_dialogue"
const HIDE_DIALOGUE = &"hide_dialogue"
const SHOW_HELP_POPUP = &"show_help_popup"
const HIDE_HELP_POPUP = &"hide_help_popup"

# hacker scene
const SHOW_LEVEL_POPUP = &"show_level_popup"

const SHOW_MAP_ITEM_DETAIL = &"show_map_item_detail"
const HIDE_MAP_ITEM_DETAIL = &"hide_map_item_detail"
const SHOW_ENEMY_PANEL = &"show_enemy_panel"
const SHOW_DATABASE_PANEL = &"show_database_panel"
const SHOW_DATA_PANEL = &"show_data_panel"
const SHOW_PLAYER_PANEL = &"show_player_panel"

const FIGHT = &"fight"
const GAMEOVER = &"gameover"
const GAME_VICTORY = &"game_victory"
const ENABLE_INPUT = &"enable_input"
const DISABLE_INPUT = &"disable_input"

const SIREN_TRIGGERED = &"siren_triggered"

const ENABLE_BLUR = &"enable_blur"
const DISABLE_BLUR = &"disable_blur"
const FIGHT_SCENE_ENABLE_BLUR = &"fight_scene_enable_blur"
const FIGHT_SCENE_DISABLE_BLUR = &"fight_scene_disable_blur"
const BLUR_PRESSED = &"blur_pressed"


const INFO_LIST = [
	[ SHOW_DIALOGUE, [ {"name":"id", "type":TYPE_INT} ]],
	[ HIDE_DIALOGUE, [ ]],
	[ SHOW_HELP_POPUP, [ ]],
	[ HIDE_HELP_POPUP, [ ]],
	
	[ SHOW_LEVEL_POPUP, [ {"name":"id", "type":TYPE_INT} ]],
	
	[ SHOW_MAP_ITEM_DETAIL, [ {"name":"item", "type":TYPE_OBJECT} ]],
	[ HIDE_MAP_ITEM_DETAIL, [ ]],
	[ SHOW_ENEMY_PANEL, [ {"name":"unit", "type":TYPE_OBJECT} ]],
	[ SHOW_PLAYER_PANEL, [ {"name":"player_unit", "type":TYPE_OBJECT} ]],
	[ SHOW_DATABASE_PANEL, [ {"name":"database", "type":TYPE_OBJECT} ]],
	[ SHOW_DATA_PANEL, [ ]],
	
	[ FIGHT, [ {"name":"unit", "type":TYPE_OBJECT} ]],
	[ GAMEOVER, [ ]],
	[ GAME_VICTORY, [ {"name":"rest_unit_count", "type":TYPE_INT}, {"name":"score", "type":TYPE_INT} ]],
	[ ENABLE_INPUT, [ ]],
	[ DISABLE_INPUT, [ ]],
	
	[ SIREN_TRIGGERED, [ ]],
	
	[ ENABLE_BLUR, [ ]],
	[ DISABLE_BLUR, [ ]],
	[ FIGHT_SCENE_ENABLE_BLUR, [ ]],
	[ FIGHT_SCENE_DISABLE_BLUR, [ ]],
	[ BLUR_PRESSED, [ ]],
]
