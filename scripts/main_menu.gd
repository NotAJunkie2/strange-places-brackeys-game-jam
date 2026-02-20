extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var options_panel: Panel = $Options_Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_buttons.visible = true
	options_panel.visible = false


func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/playground.tscn")

func _on_options_button_pressed() -> void:
	main_menu_buttons.visible = false
	options_panel.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_return_button_pressed() -> void:
	main_menu_buttons.visible = true
	options_panel.visible = false
