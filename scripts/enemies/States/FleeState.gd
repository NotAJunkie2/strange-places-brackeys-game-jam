extends State

@onready var enemy: Enemy = owner

var flee_timer: float = 0.0
var flee_direction: Vector2 = Vector2.ZERO


func enter(_previous: State) -> void:
	flee_timer = 2.5
	if enemy.target != null:
		flee_direction = (enemy.global_position - enemy.target.global_position).normalized()
	else:
		flee_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	enemy.linear_velocity = flee_direction * enemy.speed * 2.5


func process_physics(delta: float) -> void:
	flee_timer -= delta
	if flee_timer <= 0.0:
		enemy.queue_free()
