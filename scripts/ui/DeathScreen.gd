class_name DeathScreen extends Control

@export var character: Character

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

func hide_screen() -> void:
	visible = false
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		#get_tree().reload_current_scene()
		character.set_physics_process(true)
		character.set_process(true)
		character.set_process_unhandled_input(true)
		character.current_modifiers = []
		character.current_target = owner.find_child("PizzaPlace")
		character.global_position = Vector2(-772.0, -12.0)
		DeliveryManager.current_delivery = null
		character.health = 6.0
		character.health_bar.update_health(character.health)

		character.health_bar.visible = false

		hide_screen()
