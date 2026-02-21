extends CharacterBody2D
class_name Character

@export var speed: float = 450.0

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_area: Area2D = $Area2D
@onready var interact_label: Label = $InteractLabel
@onready var health_bar: HealthBar = $OrderUI/HealthBar
@onready var qte: QTEBar = $CanvasLayer/QTE
@onready var animator: AnimatedSprite2D = $Animator
@onready var target_arrow: Sprite2D = $OrderUI/TargetArrow

var is_hidden: bool = false
var can_interact: bool = false
var current_interactible: GenericInteractible = null

var health: float
var max_health: float = 6.0
var current_modifier: Enums.PizzaModifier = Enums.PizzaModifier.NORMAL
var current_target: Node2D
var arrow_radius: float = 250.0


func _ready() -> void:
	health = max_health
	health_bar.init_health(max_health)
	qte.qte_finished.connect(_on_qte_finished)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

	if Input.is_action_just_pressed("interact") and current_interactible != null:
		current_interactible.interact()


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if current_modifier == Enums.PizzaModifier.UNSTABLE:
		_unstable_damage(delta)

	if current_target and is_instance_valid(current_target):
		$OrderUI.visible = true
		# 1. Get direction in World Space
		var direction = (current_target.global_position - global_position).normalized()
		
		# 2. Set LOCAL position (relative to the CanvasLayer/Screen Center)
		# Get the center of the viewport so it orbits the middle of the screen
		var screen_center = get_viewport_rect().size / 2
		target_arrow.global_position = screen_center + (direction * arrow_radius)
		
		# 3. Apply Rotation
		target_arrow.rotation = direction.angle()
	else:
		$OrderUI.visible = false


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	animator.flip_h = velocity.x < 0


func damage(amount: float) -> void:
	if is_hidden:
		return

	qte.add_qte_to_queue(amount)


func _on_qte_finished(dodged: bool, amount: float) -> void:
	if dodged:
		return
	health -= amount
	health_bar.update_health(health)
	_damage_anim()
	if health <= 0.0:
		_die()


func _unstable_damage(delta: float) -> void:
	health -= delta / 15.0
	health_bar.update_health(health)
	if health <= 0.0:
		_die()

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


func set_modifier(modifier: Enums.PizzaModifier) -> void:
	current_modifier = modifier
	health = max_health
	health_bar.init_health(max_health)
