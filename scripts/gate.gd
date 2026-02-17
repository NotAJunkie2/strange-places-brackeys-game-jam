extends StaticBody2D

@export var unlock_stage: WorldState.DeliveryStage

func _ready():
	WorldState.stage_completed.connect(_check_unlock)
	_check_unlock()

func _check_unlock():
	if (WorldState.current_stage >= unlock_stage):
		queue_free()
