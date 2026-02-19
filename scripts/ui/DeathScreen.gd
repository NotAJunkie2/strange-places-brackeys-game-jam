class_name DeathScreen extends Control


func _ready() -> void:
	visible = false
	set_process_input(false)


func show_screen() -> void:
	visible = true
	set_process_input(true)
	# Fade in
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
