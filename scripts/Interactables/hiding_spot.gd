extends GenericInteractible

var entered_at_pos: Vector2

func _ready() -> void:
	super()
	label_on_enter = "Press E to hide"
	pass

func interact():
	if not player:
		return

	if not player.is_hidden:
		player.is_hidden = true
		# save last pos
		entered_at_pos = player.global_position
		player.global_position = self.global_position
		player.position.y -= 24
		player.interact_label.text = "Press E to exit hiding spot"
		player.state_machine.current_state.transition_sg.emit('Hide')
	elif player.is_hidden:
		player.is_hidden = false
		player.position = entered_at_pos
		player.interact_label.text = "Press E to hide"
		player.state_machine.current_state.transition_sg.emit('Idle')
