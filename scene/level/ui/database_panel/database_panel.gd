extends Panel

const DataBtnScene = preload("res://scene/level/ui/database_panel/data_btn.tscn")
const SkillPatchScene = preload("res://scene/common/map_item_view/skill_patch.tscn")

enum OptionId { ADD_HP, ADD_DEF, ADD_SPD, LEARN_SKILL, STRENGTHEN_SKILL }

var player_unit:PlayerUnit
var database:Database : set = set_database

var option_button_group := ButtonGroup.new()
var data_count:int = 0 : set = set_data_count
var max_data_count:int = 1
var strengthen_skill_state:SkillState = null : set = set_strengthen_skill_state
var target_unit_id:int = -1

var _select_skill_ui_dirty := true

@onready var data_count_label = get_data_count_label()
@onready var data_hflow_cntr = get_data_hflow_cntr()
@onready var option_vbox = get_option_vbox()
@onready var current_tex_rect = get_current_tex_rect()
@onready var result_title_label = get_result_title_label()
@onready var choose_label = get_choose_label()
@onready var result_ui_list = [ get_add_hp_ui(), get_add_def_ui(), get_add_spd_ui(), get_learn_skill_ui(), get_strengthen_skill_ui() ]
@onready var hit_rate_hbox = get_hit_rate_hbox()
@onready var strike_tex_rect = get_strike_tex_rect()
@onready var strike_label = get_strike_label()
@onready var thrust_tex_rect = get_thrust_tex_rect()
@onready var thrust_label = get_thrust_label()
@onready var slash_tex_rect = get_slash_tex_rect()
@onready var slash_label = get_slash_label()
@onready var select_skill_color_rect = get_select_skill_color_rect()
@onready var ok_btn = get_ok_btn()


func get_data_count_label() -> Label:
	return $result_panel/cost_hbox/data_count_label

func get_data_hflow_cntr():
	return $data_scroll_cntr/data_hflow_cntr

func get_option_vbox():
	return $option_vbox

func get_current_tex_rect() -> TextureRect:
	return $option_vbox/add_hp_btn/current_tex_rect

func get_choose_label():
	return $result_panel/choose_label

func get_add_hp_ui():
	return $result_panel/add_hp

func get_add_hp_label():
	return $result_panel/add_hp/hbox/hp_label

func get_add_def_ui():
	return $result_panel/add_def

func get_add_def_label():
	return $result_panel/add_def/hbox/def_label

func get_add_spd_ui():
	return $result_panel/add_spd

func get_add_spd_label():
	return $result_panel/add_spd/hbox/spd_label

func get_learn_skill_ui():
	return $result_panel/learn_skill

func get_learn_skill_patch():
	return $result_panel/learn_skill/skill_patch

func get_learn_skill_desc_label():
	return $result_panel/learn_skill/desc_patch/desc_label

func get_strengthen_skill_ui():
	return $result_panel/strengthen_skill

func get_hit_rate_hbox():
	return $result_panel/hit_rate_hbox

func get_strike_tex_rect():
	return $result_panel/hit_rate_hbox/strike_tex_rect

func get_strike_label():
	return $result_panel/hit_rate_hbox/strike_label

func get_thrust_tex_rect():
	return $result_panel/hit_rate_hbox/thrust_tex_rect

func get_thrust_label():
	return $result_panel/hit_rate_hbox/thrust_label

func get_slash_tex_rect():
	return $result_panel/hit_rate_hbox/slash_tex_rect

func get_slash_label():
	return $result_panel/hit_rate_hbox/slash_label

func get_result_title_label():
	return $result_panel/title_color_rect/title_label

func get_strengthen_empty_laebl():
	return $result_panel/strengthen_skill/skill_btn/empty_label

func get_strengthen_skill_patch():
	return $result_panel/strengthen_skill/skill_btn/skill_patch

func get_strengthen_skill_text_label() -> RichTextLabel:
	return $result_panel/strengthen_skill/patch/text_label

func get_select_skill_color_rect():
	return $select_skill_color_rect

func get_select_skill_hflow_cntr():
	return $select_skill_color_rect/skill_scroll_cntr/skill_hflow_cntr

func get_ok_btn():
	return $result_panel/ok_btn


func _ready():
	for child in option_vbox.get_children():
		child.button_group = option_button_group
	
	option_button_group.pressed.connect(_on_option_button_group_pressed)
	
	event_bus.listen(EventConst.SHOW_DATABASE_PANEL, _on_ent_show_database_panel)

func _gui_input(_event: InputEvent) -> void:
	get_tree().root.set_input_as_handled()

func _on_ent_show_database_panel(p_database):
	database = p_database
	open()

func _on_option_button_group_pressed(p_btn):
	if current_tex_rect.get_parent() == p_btn:
		return
	
	current_tex_rect.reparent(p_btn, false)
	result_title_label.text = p_btn.text
	if !choose_label.visible:
		for i in result_ui_list.size():
			if i == p_btn.get_index():
				result_ui_list[i].show()
			else:
				result_ui_list[i].hide()

func open():
	update()
	event_bus.emit_signal(EventConst.ENABLE_BLUR)
	grab_focus()
	show()

func close():
	release_focus()
	hide()
	event_bus.emit_signal(EventConst.DISABLE_BLUR)

func set_player_unit(p_value):
	player_unit = p_value

func set_database(p_value):
	database = p_value
	
	if database:
		max_data_count = database.get_cost()
		update_count()

func set_data_count(p_value):
	if data_count == p_value:
		return
	
	data_count = p_value
	update_count()

func create_data_btn(p_stack):
	var dataBtn = DataBtnScene.instantiate()
	dataBtn.data_stack = p_stack
	dataBtn.count_added.connect(_on_data_btn_count_added.bind(dataBtn))
	dataBtn.count_subbed.connect(_on_data_btn_count_subbed)
	return dataBtn

func update():
	data_count = 0
	
	for child in data_hflow_cntr.get_children():
		data_hflow_cntr.remove_child(child)
		child.queue_free()
	
	for i in player_unit.data_stack_list.size():
		var btn = create_data_btn(player_unit.data_stack_list[i])
		data_hflow_cntr.add_child(btn)
	
	_select_skill_ui_dirty = true

func update_count():
	data_count_label.text = "%d/%d" % [ data_count , max_data_count ]
	if data_count < max_data_count:
		target_unit_id = -1
	else:
		var unitCounts = []
		for child in data_hflow_cntr.get_children():
			if child.count <= 0:
				continue
			
			var find = false
			for i in unitCounts.size():
				if unitCounts[i][0] < child.count || (unitCounts[i][0] == child.count && child.data_stack.id > unitCounts[i][1]):
					unitCounts.insert(i, [child.count, child.data_stack.id])
					find = true
					break
			
			if !find:
				unitCounts.append([child.count, child.data_stack.id])
		target_unit_id = unitCounts[0][1]
	
	update_result_panel()

func update_result_panel():
	if target_unit_id <= 0:
		choose_label.show()
		for i in result_ui_list.size():
			result_ui_list[i].hide()
		
		hit_rate_hbox.hide()
		ok_btn.hide()
	else:
		choose_label.hide()
		
		var unitRow = table_set.unit.get_row(target_unit_id)
		assert(unitRow)
		get_add_hp_label().text = "+%d" % get_add_hp(unitRow)
		var addDef = get_add_def(unitRow)
		var defBtn = option_vbox.get_child(OptionId.ADD_DEF)
		if addDef > 0:
			get_add_def_label().text = "+%d" % addDef
			defBtn.show()
		else:
			if defBtn.button_pressed:
				option_vbox.get_child(0).button_pressed = true
			defBtn.hide()
		get_add_spd_label().text = "+%d" % get_add_spd(unitRow)
		var learnBtn = option_vbox.get_child(OptionId.LEARN_SKILL)
		if unitRow.learn_skill_id > 0 && !player_unit.has_skill(unitRow.learn_skill_id):
			var skill = SkillConst.create_skill_by_id(unitRow.learn_skill_id)
			get_learn_skill_patch().skill = skill
			get_learn_skill_desc_label().text = skill.get_description()
			learnBtn.show()
		else:
			if learnBtn.button_pressed:
				option_vbox.get_child(OptionId.ADD_HP).button_pressed = true
			learnBtn.hide()
		
		var strengthenBtn = option_vbox.get_child(OptionId.STRENGTHEN_SKILL)
		if unitRow.learn_skill_id > 0:
			update_strengthen_skill_text()
			strengthenBtn.show()
		else:
			if strengthenBtn.button_pressed:
				option_vbox.get_child(OptionId.ADD_HP).button_pressed = true
			strengthenBtn.hide()
		
		if unitRow.strike_hit_rate > 1.0:
			strike_label.text = "%d%%" % int((1.0 - unitRow.strike_hit_rate) * 100)
			strike_tex_rect.show()
			strike_label.show()
		else:
			strike_tex_rect.hide()
			strike_label.hide()
		
		if unitRow.thrust_hit_rate > 1.0:
			thrust_label.text = "%d%%" % int((1.0 - unitRow.thrust_hit_rate) * 100)
			thrust_tex_rect.show()
			thrust_label.show()
		else:
			thrust_tex_rect.hide()
			thrust_label.hide()
		
		if unitRow.slash_hit_rate > 1.0:
			slash_label.text = "%d%%" % int((1.0 - unitRow.slash_hit_rate) * 100)
			slash_tex_rect.show()
			slash_label.show()
		else:
			slash_tex_rect.hide()
			slash_label.hide()
		
		var optId = option_button_group.get_pressed_button().get_index()
		for i in result_ui_list.size():
			if i == optId:
				result_ui_list[i].show()
			else:
				result_ui_list[i].hide()
		hit_rate_hbox.show()
		
		if optId == 4 && strengthen_skill_state == null:
			ok_btn.hide()
		else:
			ok_btn.show()

func update_strengthen_skill_text():
	var text = ""
	if strengthen_skill_state != null && target_unit_id > 0:
		var unitRow = table_set.unit.get_row(target_unit_id)
		assert(unitRow)
		if unitRow.learn_skill_id > 0:
			var skillRow = table_set.skill.get_row(unitRow.learn_skill_id)
			assert(skillRow)
			var dam:int = get_skill_strengthen_damage(strengthen_skill_state.skill, skillRow)
			var cd:int = get_skill_strengthen_cd(strengthen_skill_state.skill, skillRow)
			var chargeCount:int = get_skill_strengthen_charge_count(strengthen_skill_state.skill, skillRow)
			
			if dam > 0:
				text += tr("LS_DB_DAMAGE_INCREASE") % dam + "\n"
			
			if skillRow.effect_id > 0:
				text += "%s\n" % tr("EFFECT_" + str(skillRow.effect_id)) 
			
			if cd > 0:
				text += tr("LS_DB_CD") % ("+%d" % cd)
			elif cd < 0:
				text += tr("LS_DB_CD") % str(cd)
			
			if chargeCount > 0:
				text += tr("LS_DB_CHARGE_COUNT") % ("+%d" % chargeCount)
			elif chargeCount < 0:
				text += tr("LS_DB_CHARGE_COUNT") % str(chargeCount)
	
	get_strengthen_skill_text_label().text = text


func get_add_hp(p_unitRow):
	return int(p_unitRow.hp)

func get_add_def(p_unitRow):
	return int(p_unitRow.def)

func get_add_spd(p_unitRow):
	return max(int(p_unitRow.spd / 5), 1)

func get_skill_strengthen_damage(p_skill:Skill, p_skillRow) -> int:
	var ret:int = 0
	var dam = 0
	match strengthen_skill_state.skill.get_damage_type():
		SkillConst.DamageType.STRIKE:
			dam = int(p_skill.get_strike_damage_strengthen_rate() * p_skillRow.strike_damage)
		SkillConst.DamageType.THRUST:
			dam = int(p_skill.get_thrust_damage_strengthen_rate() * p_skillRow.thrust_damage)
		SkillConst.DamageType.SLASH:
			dam = int(p_skill.get_slash_damage_strengthen_rate() * p_skillRow.slash_damage)
		SkillConst.DamageType.RANDOM:
			dam = int(p_skill.get_strike_damage_strengthen_rate() * p_skillRow.strike_damage + \
					p_skill.get_thrust_damage_strengthen_rate() * p_skillRow.thrust_damage + \
					p_skill.get_slash_damage_strengthen_rate() * p_skillRow.slash_damage	)
	if dam > 0:
		ret = dam
	return ret

func get_skill_strengthen_cd(p_skill:Skill, p_skillRow) -> int:
	var ret:int = 0
	if p_skillRow.effect_id > 0:
		var effectRow = table_set.effect.get_row(p_skillRow.effect_id)
		assert(effectRow)
		ret += effectRow.cd
	
	if ret < 0 && -ret > p_skill.get_cd():
		ret = -p_skill.get_cd()
	
	return ret

func get_skill_strengthen_charge_count(p_skill:Skill, p_skillRow) -> int:
	var ret:int = 0
	if p_skillRow.effect_id > 0:
		var effectRow = table_set.effect.get_row(p_skillRow.effect_id)
		assert(effectRow)
		ret += effectRow.charge_count
	
	if ret < 0 && -ret > p_skill.get_charge_count():
		ret = -p_skill.get_charge_count()
	
	return ret

func _on_data_btn_count_added(p_btn):
	if data_count >= max_data_count:
		p_btn.count -= 1
		return
	
	data_count += 1

func _on_data_btn_count_subbed():
	data_count -= 1

func set_strengthen_skill_state(p_value):
	if strengthen_skill_state == p_value:
		return
	
	strengthen_skill_state = p_value
	update_strengthen_skill_text()
	if strengthen_skill_state == null:
		get_strengthen_empty_laebl().show()
		get_strengthen_skill_patch().hide()
	else:
		get_strengthen_empty_laebl().hide()
		var skillPatch = get_strengthen_skill_patch()
		skillPatch.skill = strengthen_skill_state.skill
		skillPatch.show()
		if result_ui_list[4].visible:
			ok_btn.show()

func open_select_skill_ui():
	update_select_skill_ui()
	select_skill_color_rect.show()

func update_select_skill_ui():
	if !_select_skill_ui_dirty:
		return
	
	_select_skill_ui_dirty = false
	var skillHflow = get_select_skill_hflow_cntr()
	for child in skillHflow.get_children():
		child.queue_free()
		skillHflow.remove_child(child)
	
	for skillState in player_unit.skill_state_list:
		var skillPatch = SkillPatchScene.instantiate()
		skillPatch.skill = skillState.skill
		skillPatch.pressed.connect(_on_select_skill_skill_patch_pressed.bind(skillState))
		skillHflow.add_child(skillPatch)

func _on_select_skill_skill_patch_pressed(p_skillState):
	strengthen_skill_state = p_skillState
	select_skill_color_rect.hide()

func _on_skill_btn_pressed() -> void:
	open_select_skill_ui()

func _on_ok_btn_pressed() -> void:
	for child in data_hflow_cntr.get_children():
		if child.count > 0:
			player_unit.sub_data(child.data_stack.id, child.count)
	
	var unitRow = table_set.unit.get_row(target_unit_id)
	assert(unitRow)
	match option_button_group.get_pressed_button().get_index():
		OptionId.ADD_HP:
			player_unit.hp += get_add_hp(unitRow)
		OptionId.ADD_DEF:
			player_unit.def += get_add_def(unitRow)
		OptionId.ADD_SPD:
			player_unit.spd += get_add_spd(unitRow)
		OptionId.LEARN_SKILL:
			var state = SkillState.new()
			state.skill = SkillConst.create_skill_by_id(unitRow.learn_skill_id)
			player_unit.skill_state_list.append(state)
		OptionId.STRENGTHEN_SKILL:
			var skillRow = table_set.skill.get_row(unitRow.learn_skill_id)
			strengthen_skill_state.skill.extra_damage += get_skill_strengthen_damage(strengthen_skill_state.skill, skillRow)
			strengthen_skill_state.skill.extra_cd += get_skill_strengthen_cd(strengthen_skill_state.skill, skillRow)
			strengthen_skill_state.skill.extra_charge_count += get_skill_strengthen_charge_count(strengthen_skill_state.skill, skillRow)
			if skillRow.effect_id > 0:
				strengthen_skill_state.skill.extra_effect_list.append(skillRow.effect_id)
	
	database.use_time += 1
	
	close()


func _on_close_btn_pressed() -> void:
	close()


func _on_select_skill_close_btn_pressed() -> void:
	select_skill_color_rect.hide()
