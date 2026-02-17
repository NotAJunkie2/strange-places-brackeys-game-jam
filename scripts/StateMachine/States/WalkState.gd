class_name WalkState extends State

@onready var character: Character = owner


func process_input(event: InputEvent) -> void:
	pass

func process_physics(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if direction == Vector2.ZERO:
		transition_sg.emit("Idle")
		return

	character.velocity = direction.normalized() * character.speed
	character.move_and_slide()
