extends Node

enum DeliveryStage { TUTORIAL, TUTORIAL_2, GLITCH, GLITCH_2, HELL, HELL_2, FINAL_HQ }
var current_stage = DeliveryStage.TUTORIAL

signal stage_completed

func advance_stage():
	# If we aren't at the end yet, move to next
	if current_stage < DeliveryStage.FINAL_HQ:
		current_stage += 1 as DeliveryStage
		stage_completed.emit() # This triggers the "Gates" to open
	else:
		print("Game over! You reached the Final HQ.")
