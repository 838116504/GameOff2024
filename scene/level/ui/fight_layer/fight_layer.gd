extends CanvasLayer

var player_unit:PlayerUnit : set = set_player_unit
var fight_unit

@onready var fight_scene = get_fight_scene()

func get_fight_scene():
	return $fight_scene


func _ready():
	event_bus.listen(EventConst.FIGHT, _on_ent_fight)

func _on_ent_fight(p_unit):
	fight_unit = p_unit
	fight_scene.set_fight(player_unit, fight_unit)

func set_player_unit(p_value):
	player_unit = p_value
