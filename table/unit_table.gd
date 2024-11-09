class_name UnitTable
extends BaseIdTable

const UnitRow = preload("res://table/unit_row.gd")

@export var row_list:Array[UnitRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->UnitRow:
	return _get_row(p_id)

static func get_singleton()->UnitTable:
	return load("res://table/unit.tres")

