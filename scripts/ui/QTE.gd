class_name QTEBar extends Control

signal qte_finished(dodged: bool, damage_amount: float)

@export var sweep_duration: float = 1.5
@export var zone_size: float = 0.1

const BAR_WIDTH := 400.0
const BAR_HEIGHT := 40.0
const CURSOR_WIDTH := 4.0
const COLOR_BG := Color(0.2, 0.2, 0.2, 0.9)
const COLOR_ZONE := Color(0.8, 0.15, 0.15)
const COLOR_CURSOR := Color(1, 1, 1)
const COLOR_OUTLINE := Color(0.1, 0.1, 0.1)

var active: bool = false
var cursor_progress: float = 0.0
var zone_start: float = 0.0
var zone_end: float = 0.0
var target_key: String = "A"
var target_keycode: int = KEY_Q
var pending_damage: float = 0.0


func _ready() -> void:
	visible = false
	set_process(false)
	set_process_unhandled_input(false)


func start_qte(damage_amount: float) -> void:
	if active:
		_finish(false)

	pending_damage = damage_amount
	cursor_progress = 0.0

	# Random zone position (making sure it fits)
	zone_start = randf_range(0.2, 1.0 - zone_size - 0.05)
	zone_end = zone_start + zone_size

	# Random key: A (physical Q) or E
	if randi() % 2 == 0:
		target_key = "A"
		target_keycode = KEY_Q
	else:
		target_key = "E"
		target_keycode = KEY_E

	active = true
	visible = true
	set_process(true)
	set_process_unhandled_input(true)
	queue_redraw()


func _process(delta: float) -> void:
	if not active:
		return
	cursor_progress += delta / sweep_duration
	queue_redraw()
	if cursor_progress >= 1.0:
		_finish(false)


func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == target_keycode:
			if cursor_progress >= zone_start and cursor_progress <= zone_end:
				_finish(true)
			else:
				_finish(false)
		elif event.physical_keycode == KEY_Q or event.physical_keycode == KEY_E:
			_finish(false)


func _finish(dodged: bool) -> void:
	active = false
	visible = false
	set_process(false)
	set_process_unhandled_input(false)
	qte_finished.emit(dodged, pending_damage)


func _draw() -> void:
	if not active:
		return

	var bar_x := (size.x - BAR_WIDTH) / 2.0
	var bar_y := (size.y - BAR_HEIGHT) / 2.0
	var bar_rect := Rect2(bar_x, bar_y, BAR_WIDTH, BAR_HEIGHT)

	# Background
	draw_rect(bar_rect, COLOR_BG)

	# Red zone
	var zone_rect := Rect2(
		bar_x + zone_start * BAR_WIDTH,
		bar_y,
		zone_size * BAR_WIDTH,
		BAR_HEIGHT
	)
	draw_rect(zone_rect, COLOR_ZONE)

	# Key label in zone
	var font := ThemeDB.fallback_font
	var font_size := 20
	var text_size := font.get_string_size(target_key, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	var text_x := zone_rect.position.x + (zone_rect.size.x - text_size.x) / 2.0
	var text_y := zone_rect.position.y + (zone_rect.size.y + text_size.y) / 2.0 - 2.0
	draw_string(font, Vector2(text_x, text_y), target_key, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)

	# Cursor
	var cursor_x := bar_x + cursor_progress * BAR_WIDTH
	draw_rect(Rect2(cursor_x - CURSOR_WIDTH / 2.0, bar_y - 4, CURSOR_WIDTH, BAR_HEIGHT + 8), COLOR_CURSOR)

	# Outline
	draw_rect(bar_rect, COLOR_OUTLINE, false, 2.0)
