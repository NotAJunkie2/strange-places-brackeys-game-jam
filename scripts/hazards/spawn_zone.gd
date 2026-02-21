class_name SpawnZone extends Area2D

@export var spawn_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_delay_variation: float = 0.5

var player_in_zone: bool = false
var spawn_timer: float = 0.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_process(false)


func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn()
		spawn_timer = spawn_interval + randf_range(-spawn_delay_variation, spawn_delay_variation)


func _spawn() -> void:
	if spawn_scene == null:
		return
	var instance: Node = spawn_scene.instantiate()
	instance.global_position = _get_random_pos_in_shape()
	get_tree().current_scene.add_child(instance)


func _get_random_pos_in_shape() -> Vector2:
	var shape_node: CollisionShape2D = null
	for child in get_children():
		if child is CollisionShape2D:
			shape_node = child
			break
	if shape_node == null:
		return global_position

	var shape: Shape2D = shape_node.shape
	if shape is RectangleShape2D:
		var half: Vector2 = shape.size / 2.0
		return shape_node.global_position + Vector2(
			randf_range(-half.x, half.x),
			randf_range(-half.y, half.y)
		)
	elif shape is CircleShape2D:
		var angle: float = randf() * TAU
		var dist: float = sqrt(randf()) * shape.radius
		return shape_node.global_position + Vector2(cos(angle), sin(angle)) * dist
	return global_position


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("character"):
		print("entry")
		player_in_zone = true
		spawn_timer = spawn_interval * 0.5
		set_process(true)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("character"):
		player_in_zone = false
		set_process(false)
