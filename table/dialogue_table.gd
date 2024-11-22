class_name DialogueTable
extends BaseIdTable

const DialogueRow = preload("res://table/dialogue_row.gd")

@export var row_list:Array[DialogueRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->DialogueRow:
	return _get_row(p_id)

static func get_singleton()->DialogueTable:
	return load("res://table/dialogue.tres")

