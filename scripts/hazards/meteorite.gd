extends Node2D

@export var damage: float = 1.0
@export var warning_time: float = 1.0
@export var impact_radius: float = 60.0
@export var start_scale: float = 0.15
@export var start_offset_y: float = -200.0

@onready var sprite: Sprite2D = $Sprite2D
@export var sprites: Array[CompressedTexture2D]

var elapsed: float = 0.0
var has_impacted: bool = false


func _ready() -> void:
	sprite.scale = Vector2(start_scale, start_scale)
	sprite.position.y = start_offset_y
	sprite.texture = sprites.pick_random()


func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

	var progress: float = clamp(elapsed / warning_time, 0.0, 1.0)
	var current_scale: float = lerp(start_scale, 1.0, progress)
	sprite.scale = Vector2(current_scale, current_scale)
	sprite.position.y = lerp(start_offset_y, 0.0, progress)

	if elapsed >= warning_time and not has_impacted:
		_impact()


func _impact() -> void:
	has_impacted = true
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = impact_radius
	query.shape = circle
	query.transform = global_transform
	query.collision_mask = 1
	var results: Array[Dictionary] = space.intersect_shape(query)
	for result: Dictionary in results:
		var body: Node = result["collider"] as Node
		if body != null and body.is_in_group("character") and DeliveryManager.current_delivery != null:
			body.damage(damage)
	var tween: Tween = create_tween()
	tween.tween_interval(0.3)
	tween.tween_callback(queue_free)


func _draw() -> void:
	var progress: float = clamp(elapsed / warning_time, 0.0, 1.0)
	var shadow_radius: float = impact_radius * progress
	draw_circle(Vector2.ZERO, shadow_radius, Color(0.1, 0.1, 0.1, 0.2 + progress * 0.3))
	if not has_impacted:
		draw_arc(Vector2.ZERO, shadow_radius, 0, TAU, 32, Color(1.0, 0.3, 0.0, progress * 0.8), 2.0)
	else:
		draw_circle(Vector2.ZERO, impact_radius * 1.2, Color(1.0, 0.6, 0.0, 0.5))
