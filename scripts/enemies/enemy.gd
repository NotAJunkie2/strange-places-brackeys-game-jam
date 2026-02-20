class_name Enemy extends RigidBody2D

@export var damage: float = 1.0
@export var min_speed: float = 450.0
@export var max_speed: float = 550.0

@onready var state_machine: StateMachine = $StateMachine
@onready var hurt_box: Area2D = $Area2D
@onready var detection_area: Area2D = $DetectionArea

var speed: float = 450.0
var target: Node2D = null


func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	hurt_box.body_entered.connect(_on_hurt_box_body_entered)
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _on_detection_body_entered(body: Node) -> void:
	if body.is_in_group("character") and not body.is_hidden:
		target = body


func _on_detection_body_exited(body: Node) -> void:
	if body.is_in_group("character"):
		target = null


func _on_hurt_box_body_entered(body: Node) -> void:
	if body.is_in_group("character") and hurt_box.monitoring:
		body.damage(damage)
		hurt_box.set_deferred("monitoring", false)
		state_machine.on_child_transition(&"Flee")
