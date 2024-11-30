extends Node

var player_unit:PlayerUnit
var enabled := true


func _ready():
	event_bus.listen(EventConst.ENABLE_INPUT, _on_ent_enable_input)
	event_bus.listen(EventConst.DISABLE_INPUT, _on_ent_disable_input)

func _unhandled_input(p_event:InputEvent) -> void:
	if !enabled || player_unit == null:
		return
	
	player_unit.input(p_event)

func _on_ent_enable_input():
	enabled = true

func _on_ent_disable_input():
	enabled = false
