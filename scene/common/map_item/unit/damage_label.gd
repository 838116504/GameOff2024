extends Label

@export var start_modulate:Color = Color.RED
@export var end_modulate:Color = Color.WHITE
@export var modulate_time:float = 0.4
@export var show_time:float = 1.5
@export var fade_time:float = 1.0
@export var enlarge_time:float = 0.4
@export var shrink_time:float = 0.4
@export var shrink_ratio:float = 0.7
@export var move_vector:Vector2 = Vector2(16, -50)



func _ready():
	var tween = create_tween()
	modulate = start_modulate
	tween.tween_property(self, ^"modulate", end_modulate, modulate_time)
	tween.tween_property(self, ^"modulate:a", 0.0, fade_time).set_delay(show_time)
	tween.tween_callback(queue_free)
	
	var minSize = get_combined_minimum_size()
	position.x -= minSize.x * 0.5
	pivot_offset = minSize * 0.5
	scale = Vector2.ZERO
	var scaleTween = create_tween()
	scaleTween.tween_property(self, ^"scale", Vector2.ONE, enlarge_time)
	scaleTween.tween_property(self, ^"scale", Vector2.ONE * shrink_ratio, shrink_time)

func _process(p_delta: float) -> void:
	position += move_vector * p_delta
