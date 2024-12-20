extends BaseScene

var save_id:int

@onready var fight_scene = get_fight_scene()

func get_fight_scene() -> FightScene:
	return $fight_scene

func _ready():
	var playerUnit = PlayerUnit.new()
	playerUnit.set_unit_id(2)
	var enemy = Unit.create_by_unit_set_id(50)
	fight_scene.set_fight(playerUnit, enemy)
	var startEnt = StartDialgoueEvent.new()
	startEnt.dialogue_id = 1
	fight_scene.add_fight_event(startEnt)
	var hpEnt = PlayerHPDialogueEvent.new()
	hpEnt.player_hp = 600
	hpEnt.dialogue_id = 3
	fight_scene.add_fight_event(hpEnt)
	var loseEnt = LoseDialogueEvent.new()
	loseEnt.dialogue_id = 5
	fight_scene.add_fight_event(loseEnt)
	var showHelpPopupEnt = ShowHelpPopupEvent.new()
	fight_scene.add_fight_event(showHelpPopupEnt)


func _on_fight_scene_losed() -> void:
	var hackerScene = load(ScenePathConst.HACKER_SCENE).instantiate()
	hackerScene.save_id = save_id
	scene_transition.change_scene(hackerScene, "fade_out", "fade_in")
