class_name StateMachine extends Node

@export var initial_state: NodePath
var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition_sg.connect(on_child_transition)
	await owner.ready
	if initial_state:
		current_state = get_node(initial_state)
	if current_state == null and not states.is_empty():
		current_state = states.values()[0]
	if current_state:
		current_state.enter(null)


func process_input(event: InputEvent) -> void:
	if current_state:
		current_state.process_input(event)


func process_frame(delta: float) -> void:
	if current_state:
		current_state.process_frame(delta)


func process_physics(delta: float) -> void:
	if current_state:
		current_state.process_physics(delta)


func on_child_transition(new_state_name: StringName) -> void:
	var new_state: State = states.get(new_state_name)
	if new_state == null:
		push_warning("State does not exist: ", new_state_name)
		return
	var previous: State = current_state
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter(previous)
