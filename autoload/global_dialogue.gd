extends Node

signal ended

const LAYER = 9
const DialogueUIScene = preload("res://scene/common/dialogue_ui/dialogue_ui.tscn")

var canvas_layer:CanvasLayer
var dialogue_ui

func _init():
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = LAYER
	canvas_layer.hide()
	add_child(canvas_layer)
	
	dialogue_ui = DialogueUIScene.instantiate()
	canvas_layer.add_child(dialogue_ui)

func _ready():
	event_bus.listen(EventConst.SHOW_DIALOGUE, _on_ent_show_dialogue)
	event_bus.listen(EventConst.HIDE_DIALOGUE, _on_ent_hide_dialogue)

func show_dialogue(p_id):
	canvas_layer.show()
	dialogue_ui.set_dialogue_id(p_id)

func hide_dialogue():
	canvas_layer.hide()
	ended.emit()

func is_dialoguing():
	return canvas_layer.visible

func _on_ent_show_dialogue(p_id):
	show_dialogue(p_id)

func _on_ent_hide_dialogue():
	hide_dialogue()
