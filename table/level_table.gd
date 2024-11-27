class_name LevelTable
extends BaseIdTable

const LevelRow = preload("res://table/level_row.gd")

@export var row_list:Array[LevelRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->LevelRow:
	return _get_row(p_id)

static func get_singleton()->LevelTable:
	return load("res://table/level.tres")

