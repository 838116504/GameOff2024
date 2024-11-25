extends Control

@export var current_tab_font_size:float = 32
@export var tab_font_size:float = 20

var tab_button_group := ButtonGroup.new()
var page_id:int = 0

var _animing := false

@onready var panel = get_panel()
@onready var tab_hbox = get_tab_hbox()
@onready var page_root_patch = get_page_root_patch()

func get_panel():
	return $panel

func get_tab_hbox():
	return $panel/tab_hbox

func get_page_root_patch():
	return $panel/page_root_patch


func _ready():
	for child in tab_hbox.get_children():
		child.button_group = tab_button_group
	
	event_bus.listen(EventConst.SHOW_HELP_POPUP, _on_ent_show_help_popup)
	event_bus.listen(EventConst.HIDE_HELP_POPUP, _on_ent_hide_help_popup)
	tab_button_group.pressed.connect(_on_tab_button_group_pressed)



func _gui_input(p_event:InputEvent):
	get_tree().root.set_input_as_handled()
	if p_event is InputEventMouseButton && p_event.button_index == MOUSE_BUTTON_LEFT:
		if p_event.is_released():
			event_bus.emit_signal(EventConst.HIDE_HELP_POPUP)


func _on_ent_show_help_popup():
	open()

func _on_ent_hide_help_popup():
	close()

func open():
	if _animing:
		return
	
	_animing = true
	event_bus.emit_signal(EventConst.ENABLE_BLUR)
	get_tree().paused = true
	grab_focus()
	show()
	var tween = create_tween()
	panel.scale = Vector2.ZERO
	tween.tween_property(panel, "scale", Vector2.ONE, 0.3)
	await tween.finished
	_animing = false

func close():
	if _animing:
		return
	
	_animing = true
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	release_focus()
	hide()
	event_bus.emit_signal(EventConst.DISABLE_BLUR)
	get_tree().paused = false
	_animing = false

func switch_page(p_id:int):
	if page_id == p_id:
		return
	
	var prevBtn = tab_hbox.get_child(page_id)
	prevBtn.add_theme_font_size_override(&"font_size", tab_font_size)
	var prevPage = page_root_patch.get_child(page_id)
	prevPage.hide()
	
	page_id = p_id
	var btn = tab_hbox.get_child(p_id)
	btn.add_theme_font_size_override(&"font_size", current_tab_font_size)
	btn.button_pressed = true
	var page = page_root_patch.get_child(p_id)
	page.show()

func _on_tab_button_group_pressed(p_btn):
	switch_page(p_btn.get_index())
