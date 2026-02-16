class_name WalkState extends State

@onready var character: Character = owner


func process_physics(delta: float) -> void:
	# Gravity
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta
		transition_sg.emit("Fall")
		return

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	character.velocity.x = direction * character.speed

	# Jump
	if Input.is_action_just_pressed("jump"):
		transition_sg.emit("Jump")
		return

	character.move_and_slide()
