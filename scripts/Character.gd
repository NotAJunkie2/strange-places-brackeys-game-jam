class_name Character extends CharacterBody2D

@export var speed: float = 200.0

@onready var state_machine: StateMachine = $StateMachine


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
