class_name Enemy extends RigidBody2D

@export var damage: float = 1.0
@export var min_speed: float = 300.0
@export var max_speed: float = 350.0

@onready var state_machine: StateMachine = $StateMachine
@onready var hurt_box: Area2D = $Area2D
@onready var detection_area: Area2D = $DetectionArea
@onready var animator: AnimatedSprite2D = $Animator

const ANIMATIONS: Array[String] = ["black_cat", "brown_cat", "ginger_cat", "white_cat"]

var speed: float = 450.0
var target: Node2D = null


func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	hurt_box.body_entered.connect(_on_hurt_box_body_entered)
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)
	animator.play(ANIMATIONS.pick_random())


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	animator.flip_h = not linear_velocity.x < 0


func _on_detection_body_entered(body: Node) -> void:
	if body.is_in_group("character") and not body.is_hidden:
		target = body


func _on_detection_body_exited(body: Node) -> void:
	if body.is_in_group("character"):
		target = null


func _on_hurt_box_body_entered(body: Node) -> void:
	if body.is_in_group("character"):
		body.damage(damage)
		state_machine.on_child_transition(&"Flee")
