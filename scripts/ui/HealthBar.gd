class_name HealthBar extends Control

const PIZZA_RADIUS := 50.0
const CRUST_WIDTH := 6.0
const COLOR_FULL := Color(0.95, 0.75, 0.2)
const COLOR_CRUST := Color(0.75, 0.5, 0.15)
const COLOR_SAUCE := Color(0.8, 0.2, 0.1)
const COLOR_EMPTY := Color(0.15, 0.15, 0.15, 0.3)
const COLOR_OUTLINE := Color(0.1, 0.1, 0.1, 0.8)

var max_hp: int = 6
var current_hp: int = 6


func _ready() -> void:
	custom_minimum_size = Vector2(PIZZA_RADIUS * 2 + 20, PIZZA_RADIUS * 2 + 20)


func init_health(new_max_hp: int) -> void:
	max_hp = new_max_hp
	current_hp = new_max_hp
	queue_redraw()


func update_health(hp: int) -> void:
	current_hp = hp
	queue_redraw()


func _draw() -> void:
	if max_hp <= 0:
		return

	var center := Vector2(PIZZA_RADIUS + 10, PIZZA_RADIUS + 10)
	var slice_angle := TAU / max_hp
	var start_offset := -PI / 2

	# Draw each slice
	for i in max_hp:
		var angle_start := start_offset + i * slice_angle
		var angle_end := angle_start + slice_angle
		var color: Color = COLOR_FULL if i < current_hp else COLOR_EMPTY

		# Pizza slice (filled triangle/arc)
		var points := PackedVector2Array()
		points.append(center)
		var steps := 12
		for s in range(steps + 1):
			var a := angle_start + (angle_end - angle_start) * s / steps
			points.append(center + Vector2(cos(a), sin(a)) * PIZZA_RADIUS)
		draw_colored_polygon(points, color)

		# Sauce layer (slightly smaller)
		if i < current_hp:
			var sauce_points := PackedVector2Array()
			sauce_points.append(center)
			var inner_r := PIZZA_RADIUS - CRUST_WIDTH
			for s in range(steps + 1):
				var a := angle_start + (angle_end - angle_start) * s / steps
				sauce_points.append(center + Vector2(cos(a), sin(a)) * inner_r)
			draw_colored_polygon(sauce_points, COLOR_SAUCE)

			# Cheese on top (smaller again)
			var cheese_points := PackedVector2Array()
			cheese_points.append(center)
			var cheese_r := PIZZA_RADIUS - CRUST_WIDTH - 4
			for s in range(steps + 1):
				var a := angle_start + (angle_end - angle_start) * s / steps
				cheese_points.append(center + Vector2(cos(a), sin(a)) * cheese_r)
			draw_colored_polygon(cheese_points, COLOR_FULL)

	# Slice divider lines
	for i in max_hp:
		var angle := start_offset + i * slice_angle
		var edge := center + Vector2(cos(angle), sin(angle)) * PIZZA_RADIUS
		draw_line(center, edge, COLOR_OUTLINE, 1.5)

	# Outer circle outline
	draw_arc(center, PIZZA_RADIUS, 0, TAU, 64, COLOR_OUTLINE, 2.0)
