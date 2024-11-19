class_name EffectTable
extends BaseIdTable

const EffectRow = preload("res://table/effect_row.gd")

@export var row_list:Array[EffectRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->EffectRow:
	return _get_row(p_id)

static func get_singleton()->EffectTable:
	return load("res://table/effect.tres")

