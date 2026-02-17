extends Node

enum DeliveryStage { TUTORIAL, GLITCH, HELL, HELL_2, FINAL_HQ }
var current_stage = DeliveryStage.TUTORIAL

signal stage_completed
