extends Control

var anim_playing := false

func get_save_vbox():
	return $panel/save_vbox

func get_anim_player() -> AnimationPlayer:
	return $anim_player

func get_dark_color_rect():
	return $dark_color_rect

func _ready():
	var saveVbox = get_save_vbox()
	for i in saveVbox.get_child_count():
		var child = saveVbox.get_child(i)
		child.id = i
		child.load_btn_pressed.connect(_on_save_ui_load_btn_pressed.bind(child))
		child.new_btn_pressed.connect(_on_save_ui_new_btn_pressed.bind(child))

func open():
	if anim_playing:
		return
	
	grab_focus()
	show()
	get_dark_color_rect().reset()
	
	anim_playing = true
	var animPlayer = get_anim_player()
	animPlayer.play("open")
	await animPlayer.animation_finished
	anim_playing = false


func close():
	if anim_playing:
		return
	
	anim_playing = true
	var animPlayer = get_anim_player()
	animPlayer.play("close")
	await animPlayer.animation_finished
	release_focus()
	hide()
	get_dark_color_rect().reset()
	anim_playing = false

func _on_save_ui_load_btn_pressed(p_saveUI):
	anim_playing = true
	
	var hackerScene = load(ScenePathConst.HACKER_SCENE).instantiate()
	hackerScene.save_id = p_saveUI.id
	scene_transition.change_scene(hackerScene, "fade_out", "fade_in")

func _on_save_ui_new_btn_pressed(p_saveUI):
	anim_playing = true
	
	var gameStartScene = load(ScenePathConst.GAME_START_SCENE).instantiate()
	gameStartScene.save_id = p_saveUI.id
	scene_transition.change_scene(gameStartScene, "fade_out", "fade_in")

func _on_back_btn_pressed() -> void:
	close()
