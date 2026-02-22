extends GenericInteractible

@export var all_deliveries: Array[DeliveryData]
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	super ()
	if WorldState.current_stage != WorldState.DeliveryStage.DELIVERY_5:
		label_on_enter = "Press E to pickup the next order"
	else:
		label_on_enter = "Good job! You finished the game. Press E to go to main menu!"

func interact():
	if not player:
		return

	if DeliveryManager.current_delivery != null:
		player.interact_label.text = "You already have your order! head to " + DeliveryManager.current_delivery.address
		return

	var current_stage = WorldState.current_stage
	if current_stage < all_deliveries.size():
		var order = all_deliveries[current_stage]
		player.health = 6.0
		player.health_bar.update_health(player.health)
		audioPlayer.play()
		DeliveryManager.start_delivery(order) # This emits the signal
	else:
		print("Game done!")
		get_tree().change_scene_to_file("res://scene/main_menu.tscn")
