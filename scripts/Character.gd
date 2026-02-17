class_name Character extends CharacterBody2D

@export var speed: float = 450.0

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_area: Area2D = $Area2D
@onready var interact_label: Label = $InteractLabel

var is_hidden: bool = false
var can_interact: bool = false
var current_interactible: GenericInteractible = null

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

	if Input.is_action_just_pressed("interact") and current_interactible != null:
		current_interactible.interact()


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
