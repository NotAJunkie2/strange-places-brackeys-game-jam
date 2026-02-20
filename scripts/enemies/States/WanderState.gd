extends State

@onready var enemy: Enemy = owner

var direction: Vector2 = Vector2.ZERO
var timer: float = 0.0


func enter(_previous: State) -> void:
	_pick_random_direction()


func exit() -> void:
	enemy.linear_velocity = Vector2.ZERO


func process_physics(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		_pick_random_direction()

	enemy.linear_velocity = direction * enemy.speed

	if enemy.target != null and not enemy.target.is_hidden:
		transition_sg.emit(&"Chase")


func _pick_random_direction() -> void:
	var angle := randf() * TAU
	direction = Vector2(cos(angle), sin(angle))
	timer = randf_range(1.0, 2.5)
