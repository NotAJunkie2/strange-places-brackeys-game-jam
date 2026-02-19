class_name Character extends CharacterBody2D

@export var speed: float = 450.0

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_area: Area2D = $Area2D
@onready var interact_label: Label = $InteractLabel
@onready var health_bar: HealthBar = $CanvasLayer/HealthBar

var is_hidden: bool = false
var can_interact: bool = false
var current_interactible: GenericInteractible = null

var health: int
var max_health: int = 3

const MODIFIER_HEALTH := {
	Enums.PizzaModifier.FRAGILE: 1,
	Enums.PizzaModifier.UNSTABLE: 3,
	Enums.PizzaModifier.UMBRAL: 6,
	Enums.PizzaModifier.SUCCULENT: 6,
	Enums.PizzaModifier.NORMAL: 6,
}


func _ready() -> void:
	health = max_health
	health_bar.init_health(max_health)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

	if Input.is_action_just_pressed("interact") and current_interactible != null:
		current_interactible.interact()


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func damage(amount: int) -> void:
	health -= amount
	health_bar.update_health(health)
	_damage_anim()
	if health <= 0:
		_die()
		return


func _damage_anim() -> void:
	var tween := create_tween()
	modulate = Color(1, 0.3, 0.3)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func _die() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_unhandled_input(false)
	velocity = Vector2.ZERO
	var death_screen: Control = $CanvasLayer/DeathScreen
	death_screen.show_screen()


#permet de set le modifier au player
func set_modifier(modifier: Enums.PizzaModifier) -> void:
	max_health = MODIFIER_HEALTH.get(modifier, 6)
	health = max_health
	health_bar.init_health(max_health)
