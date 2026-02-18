extends Node

# These signals allow the Buildings and UI to react instantly
signal delivery_started(data: DeliveryData)
signal delivery_completed

var current_delivery: DeliveryData

func start_delivery(data: DeliveryData):
	current_delivery = data
	delivery_started.emit(data) # This tells the specific house to "light up"
	print("Delivery started for: ", data.client)

func complete_delivery():
	if current_delivery == null: return
	
	# 1. Advance the game stage before clearing the data
	WorldState.advance_stage() 
	
	# 2. Cleanup
	current_delivery = null
	delivery_completed.emit() # This tells the UI to hide the pizza icon
	print("Delivery ended. Stage is now: ", WorldState.current_stage)
