class_name IdleState extends State

@onready var character: Character = owner


func enter(_previous: State) -> void:
	character.velocity = Vector2.ZERO


func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and character.can_hide:
		transition_sg.emit("Hidden")


func process_physics(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if direction != Vector2.ZERO:
		transition_sg.emit("Walk")
