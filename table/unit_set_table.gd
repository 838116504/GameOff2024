class_name UnitSetTable
extends BaseIdTable

const UnitSetRow = preload("res://table/unit_set_row.gd")

@export var row_list:Array[UnitSetRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->UnitSetRow:
	return _get_row(p_id)

static func get_singleton()->UnitSetTable:
	return load("res://table/unit_set.tres")

