class_name FallState extends State

@onready var character: Character = owner


func process_physics(delta: float) -> void:
	# Gravity
	character.velocity.y += character.gravity * delta

	# Horizontal movement in air
	var direction := Input.get_axis("move_left", "move_right")
	character.velocity.x = direction * character.speed

	character.move_and_slide()

	# Landed
	if character.is_on_floor():
		transition_sg.emit("Walk")
