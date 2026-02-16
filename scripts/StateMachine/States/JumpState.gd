class_name JumpState extends State

@onready var character: Character = owner


func enter(_previous: State) -> void:
	character.velocity.y = character.jump_velocity


func process_physics(delta: float) -> void:
	# Gravity
	character.velocity.y += character.gravity * delta

	# Horizontal movement in air
	var direction := Input.get_axis("move_left", "move_right")
	character.velocity.x = direction * character.speed

	character.move_and_slide()

	# Transition to Fall when starting to descend
	if character.velocity.y >= 0:
		transition_sg.emit("Fall")
		return

	# Safety: landed during jump
	if character.is_on_floor():
		transition_sg.emit("Walk")
