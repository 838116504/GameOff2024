extends ColorRect

@export var generate_label_scene:PackedScene
@export var start_generate_interval:float = 1.0
@export var min_generate_interval:float = 0.18
@export var generate_decrease:float = 0.15
@export var start_generate_count:int = 3
@export var max_generate_count:int = 8
@export var generate_count_increase:int = 1
@export var pivot_ratio:float = 0.75
@export var min_line_count:int = 5
@export var max_line_count:int = 8


var _rest_generate_time:float = 0
var _generate_count = start_generate_count
var _generate_interval = start_generate_interval

func _ready():
	randomize()
	set_process(is_visible_in_tree())


func reset():
	_generate_count = start_generate_count
	_generate_interval = start_generate_interval
	
	for child in get_children():
		child.queue_free()
		remove_child(child)
	
	set_process(is_visible_in_tree())

func _process(p_delta:float) -> void:
	_rest_generate_time -= p_delta
	if _rest_generate_time <= 0:
		generate_label()

func generate_label():
	for _i in _generate_count:
		var label = generate_label_scene.instantiate()
		label.line_count = randi_range(min_line_count, max_line_count)
		label.position = Vector2(randi_range(-80, 2000), randi_range(-120, 1200))
		var offset = (label.position - Vector2(960, 540)) * pivot_ratio
		label.position -= label.pivot_offset
		label.pivot_offset -= offset
		label.enable()
		add_child(label)
	
	_rest_generate_time = _generate_interval
	_generate_interval = max(_generate_interval - generate_decrease, min_generate_interval)
	_generate_count = min(_generate_count + generate_count_increase, max_generate_count)
