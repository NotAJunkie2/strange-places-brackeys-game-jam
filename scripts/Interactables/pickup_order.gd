extends GenericInteractible

@export var all_deliveries: Array[DeliveryData]

func _ready() -> void:
	super()
	if WorldState.current_stage != WorldState.DeliveryStage.FINAL_HQ:
		label_on_enter = "Press E to pickup the next order"
	pass


func interact():
	if not player:
		return

	if DeliveryManager.current_delivery != null:
		player.interact_label.text = "You already have your order! head to " + DeliveryManager.current_delivery.address
		return

	var current_stage = WorldState.current_stage
	if current_stage < all_deliveries.size():
		var order = all_deliveries[current_stage]
		DeliveryManager.start_delivery(order) # This emits the signal
