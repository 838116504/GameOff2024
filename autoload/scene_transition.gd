extends Node

signal finished

const SETTING_TRANSITION_SCENE_PATH = "addon/scene_transition/transtion_path"
const TRANSITION_LAYER = 100

var transition

func _ready():
	var scenePath = ProjectSettings.get_setting(SETTING_TRANSITION_SCENE_PATH)
	assert(scenePath)
	
	var scene = load(scenePath)
	if scene && scene is PackedScene:
		var canvasLayer = CanvasLayer.new()
		canvasLayer.layer = TRANSITION_LAYER
		add_child(canvasLayer)
		
		transition = scene.instantiate()
		canvasLayer.add_child(transition)

func play(p_name:StringName):
	assert(transition)
	if p_name.is_empty():
		return
	
	await transition.play(p_name)

func change_scene(p_scene:Node, p_out:StringName, p_in:StringName):
	assert(p_scene)
	
	if !p_out.is_empty():
		await play(p_out)
	
	var prevScene = get_tree().current_scene
	
	p_scene.tree_entered.connect(_on_current_scene_tree_entered.bind(p_scene), CONNECT_ONE_SHOT)
	get_tree().root.add_child(p_scene)
	get_tree().root.update_mouse_cursor_state()
	
	#get_tree().root.remove_child(prevScene)
	prevScene.queue_free()
	
	if !p_in.is_empty():
		await play(p_in)
	
	transition.reset()
	finished.emit()

func _on_current_scene_tree_entered(p_scene):
	get_tree().current_scene = p_scene
