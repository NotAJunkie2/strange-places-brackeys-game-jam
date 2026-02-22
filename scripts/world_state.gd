extends Node

enum DeliveryStage {DELIVERY_1, DELIVERY_2, DELIVERY_3, DELIVERY_4, DELIVERY_5}
var current_stage: DeliveryStage = DeliveryStage.DELIVERY_1
var attack_slot_occupied: bool = false
var current_biome: Enums.Biome = Enums.Biome.NORMAL

signal stage_completed

func advance_stage():
	# If we aren't at the end yet, move to next
	if current_stage < 6:
		current_stage += 1 as DeliveryStage
		stage_completed.emit() # This triggers the "Gates" to open
	else:
		print("Game complete! Final delivery done.")
