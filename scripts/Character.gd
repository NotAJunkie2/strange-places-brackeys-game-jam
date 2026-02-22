extends CharacterBody2D
class_name Character

@export var speed: float = 200.0
@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_area: Area2D = $Area2D
@onready var interact_label: Label = $InteractLabel
@onready var health_bar: HealthBar = $OrderUI/HealthBar
@onready var qte: QTEBar = $CanvasLayer/QTE
@onready var animator: AnimatedSprite2D = $Animator
@onready var target_arrow: Sprite2D = $OrderUI/TargetArrow


enum PlayerSoundTypes {Sound_DMG, Sound_DEATH, Sound_DARKNESS}
@onready var audioPlayerSounds: AudioStreamPlayer = $PlayerNoises
@onready var bgm_player: Bgm_player = $BgmPlayer

@export var dict_sounds: Dictionary[PlayerSoundTypes, AudioStream]

var is_hidden: bool = false
var can_interact: bool = false
var current_interactible: GenericInteractible = null

var health: float
var max_health: float = 6.0
var current_modifiers: Array[Enums.PizzaModifier] = []
var current_target: Node2D
var arrow_radius: float = 250.0

var umbral_layer: CanvasLayer
var umbral_material: ShaderMaterial
var succulent_timer: float = 0.0


func _ready() -> void:
	health = max_health
	health_bar.init_health(max_health)
	qte.qte_finished.connect(_on_qte_finished)
	DeliveryManager.delivery_started.connect(_on_delivery_started)
	DeliveryManager.delivery_completed.connect(_on_delivery_completed)
	_setup_umbral()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

	if Input.is_action_just_pressed("interact") and current_interactible != null:
		current_interactible.interact()


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if current_modifiers.has(Enums.PizzaModifier.UNSTABLE):
		_unstable_damage(delta)
	if current_modifiers.has(Enums.PizzaModifier.SUCCULENT):
		succulent_timer -= delta
		if succulent_timer <= 0.0:
			qte.add_qte_to_queue(1.0)
			succulent_timer = randf_range(5.0, 10.0)
	if umbral_layer.visible:
		var screen_pos: Vector2 = get_global_transform_with_canvas().origin
		umbral_material.set_shader_parameter("player_screen_pos", screen_pos)

	if current_target and is_instance_valid(current_target):
		target_arrow.visible = true
		var direction: Vector2 = (current_target.global_position - global_position).normalized()
		var screen_center: Vector2 = get_viewport_rect().size / 2
		target_arrow.global_position = screen_center + (direction * arrow_radius)
		target_arrow.rotation = direction.angle()
	else:
		target_arrow.visible = false


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
	audioPlayerSounds.stream = dict_sounds[PlayerSoundTypes.Sound_DMG]
	audioPlayerSounds.play()
	if health <= 0.0:
		_die()


func _unstable_damage(delta: float) -> void:
	health -= delta / 15.0
	health_bar.update_health(health)
	if health <= 0.0:
		_die()

func _damage_anim() -> void:
	var tween: Tween = create_tween()
	modulate = Color(1, 0.3, 0.3)
	tween.tween_property(self , "modulate", Color.WHITE, 0.3)


func _die() -> void:
	qte.qte_queue = []
	qte._finish(true)

	umbral_layer.visible = false

	bgm_player._on_toggleGlitched(true)
	bgm_player._stop_main_track()
	set_physics_process(false)
	set_process(false)
	set_process_unhandled_input(false)
	velocity = Vector2.ZERO
	audioPlayerSounds.stream = dict_sounds[PlayerSoundTypes.Sound_DEATH]
	audioPlayerSounds.play()
	var death_screen: Control = $CanvasLayer/DeathScreen
	death_screen.show_screen()


func _setup_umbral() -> void:
	umbral_layer = CanvasLayer.new()
	umbral_layer.layer = 1
	umbral_layer.name = "umbral_layer"
	add_child(umbral_layer)
	var rect: ColorRect = ColorRect.new()
	rect.anchor_right = 1.0
	rect.anchor_bottom = 1.0
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	umbral_material = ShaderMaterial.new()
	umbral_material.shader = preload("res://shaders/umbral.gdshader")
	rect.material = umbral_material
	umbral_layer.add_child(rect)
	umbral_layer.visible = false


func _on_delivery_started(data: DeliveryData) -> void:
	current_modifiers = data.modifier.duplicate()
	health = max_health
	health_bar.init_health(max_health)
	umbral_layer.visible = current_modifiers.has(Enums.PizzaModifier.UMBRAL)
	if (umbral_layer.visible == true):
		audioPlayerSounds.stream = dict_sounds[PlayerSoundTypes.Sound_DARKNESS]
		audioPlayerSounds.play()
		bgm_player._stop_main_track()
	if current_modifiers.has(Enums.PizzaModifier.SUCCULENT):
		succulent_timer = randf_range(5.0, 10.0)


func _on_delivery_completed() -> void:
	bgm_player._start_main_track()
	current_modifiers.clear()
	umbral_layer.visible = false
