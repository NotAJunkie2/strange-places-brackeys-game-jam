class_name HealthBar extends Control

const PIZZA_RADIUS := 50.0
const CRUST_WIDTH := 6.0
const COLOR_FULL := Color(0.95, 0.75, 0.2)
const COLOR_CRUST := Color(0.75, 0.5, 0.15)
const COLOR_SAUCE := Color(0.8, 0.2, 0.1)
const COLOR_EMPTY := Color(0.15, 0.15, 0.15, 0.3)
const COLOR_OUTLINE := Color(0.1, 0.1, 0.1, 0.8)

var max_hp: float = 6.0
var current_hp: float = 6.0


func _ready() -> void:
	custom_minimum_size = Vector2(PIZZA_RADIUS * 2 + 20, PIZZA_RADIUS * 2 + 20)


func init_health(new_max_hp: float) -> void:
	max_hp = new_max_hp
	current_hp = new_max_hp
	queue_redraw()


func update_health(hp: float) -> void:
	current_hp = hp
	queue_redraw()

func _process(_delta: float) -> void:
	if DeliveryManager.current_delivery != null:
		visible = true
	else:
		visible = false

func _draw() -> void:
	if max_hp <= 0.0:
		return

	var total_slices := int(max_hp)
	var center := Vector2(PIZZA_RADIUS + 10, PIZZA_RADIUS + 10)
	var slice_angle := TAU / total_slices
	var start_offset := -PI / 2
	var full_slices := int(floor(current_hp))
	var fraction := fmod(current_hp, 1.0) if current_hp > 0.0 else 0.0
	var steps := 12

	for i in total_slices:
		var angle_start := start_offset + i * slice_angle
		var angle_end := angle_start + slice_angle

		# Background (empty slice)
		_draw_slice(center, angle_start, angle_end, PIZZA_RADIUS, steps, COLOR_EMPTY)

		if i < full_slices:
			# Full slice
			_draw_full_slice(center, angle_start, angle_end, steps)
		elif i == full_slices and fraction > 0.0:
			# Partial slice
			var partial_end := angle_start + slice_angle * fraction
			_draw_full_slice(center, angle_start, partial_end, steps)

	# Slice divider lines
	for i in total_slices:
		var angle := start_offset + i * slice_angle
		var edge := center + Vector2(cos(angle), sin(angle)) * PIZZA_RADIUS
		draw_line(center, edge, COLOR_OUTLINE, 1.5)

	# Outer circle outline
	draw_arc(center, PIZZA_RADIUS, 0, TAU, 64, COLOR_OUTLINE, 2.0)


func _draw_slice(center: Vector2, a_start: float, a_end: float, radius: float, steps: int, color: Color) -> void:
	var points := PackedVector2Array()
	points.append(center)
	for s in range(steps + 1):
		var a := a_start + (a_end - a_start) * s / steps
		points.append(center + Vector2(cos(a), sin(a)) * radius)
	draw_colored_polygon(points, color)


func _draw_full_slice(center: Vector2, a_start: float, a_end: float, steps: int) -> void:
	# Crust
	_draw_slice(center, a_start, a_end, PIZZA_RADIUS, steps, COLOR_CRUST)
	# Sauce
	_draw_slice(center, a_start, a_end, PIZZA_RADIUS - CRUST_WIDTH, steps, COLOR_SAUCE)
	# Cheese
	_draw_slice(center, a_start, a_end, PIZZA_RADIUS - CRUST_WIDTH - 4, steps, COLOR_FULL)
