class_name SkillTable
extends BaseIdTable

const SkillRow = preload("res://table/skill_row.gd")

@export var row_list:Array[SkillRow]

func get_row_list():
	return row_list

func get_row(p_id:int)->SkillRow:
	return _get_row(p_id)

static func get_singleton()->SkillTable:
	return load("res://table/skill.tres")

