extends State

@onready var enemy: Enemy = owner


func enter(_previous: State) -> void:
	pass


func exit() -> void:
	enemy.linear_velocity = Vector2.ZERO


func process_physics(_delta: float) -> void:
	if enemy.target == null or enemy.target.is_hidden:
		transition_sg.emit(&"Wander")
		return

	var direction: Vector2 = (enemy.target.global_position - enemy.global_position).normalized()
	enemy.linear_velocity = direction * enemy.speed
