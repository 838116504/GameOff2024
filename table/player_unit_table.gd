class_name PlayerUnitTable
extends BaseIdTable

const PlayerUnitRow = preload("res://table/player_unit_row.gd")

@export var row_list:Array[PlayerUnitRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->PlayerUnitRow:
	return _get_row(p_id)

static func get_singleton()->PlayerUnitTable:
	return load("res://table/player_unit.tres")

