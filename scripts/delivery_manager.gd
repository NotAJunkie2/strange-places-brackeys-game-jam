extends Node

var current_delivery: DeliveryData

func start_delivery(data: DeliveryData):
	current_delivery = data
	# Set modifiers...
	# etc...

func end_delivery():
	current_delivery = null
	# Clear delivery, advance stage etc...
