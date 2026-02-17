extends GenericInteractible

@export var deliveries: Array[DeliveryData] # Drag your 5 .tres files here in order


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

	var stage = WorldState.current_stage
	
	print("Stage: ", stage)
	
	# Check if we have a delivery for this stage
	if stage < deliveries.size():
		var pizza_to_give = deliveries[stage]
		DeliveryManager.start_delivery(pizza_to_give)
		
		# Feedback for the player
		player.interact_label.text = "Picked up " + pizza_to_give.address
		print("Order started: ", pizza_to_give.pizza_type)
	else:
		print("No more orders! The world is ending.")
