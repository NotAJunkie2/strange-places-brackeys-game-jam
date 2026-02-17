class_name HiddenState extends State

@onready var character: Character = owner


func enter(_previous: State) -> void:
	character.velocity = Vector2.ZERO
	character.modulate.a = 0.3
	# Remove from player layer so enemies can't detect us MAYBE CHANGE TODO
	character.set_collision_layer_value(1, false)


func process_physics(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if direction != Vector2.ZERO:
		transition_sg.emit("Idle")


func exit() -> void:
	character.modulate.a = 1.0
	character.set_collision_layer_value(1, true)
