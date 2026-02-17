class_name Character extends CharacterBody2D

@export var speed: float = 200.0

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_area: Area2D = $Area2D
@onready var interact_label: Label = $InteractLabel

var can_hide: bool = false


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	_update_interaction()


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _update_interaction() -> void:
	can_hide = false
	for area in interaction_area.get_overlapping_areas():
		if area is HideableSpot:
			can_hide = true
			break
	interact_label.visible = can_hide
