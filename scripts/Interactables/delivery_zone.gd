@tool
extends GenericInteractible
class_name DeliveryZone

@export var delivery_order: DeliveryData:
	set(value):
		delivery_order = value
		_update_visuals()

func _ready() -> void:
	super()
	if not Engine.is_editor_hint():
		_set_active_state(false)
		# Listen to the global manager
		DeliveryManager.delivery_started.connect(_on_delivery_started)
		DeliveryManager.delivery_completed.connect(_on_delivery_completed)

func _update_visuals():
	# If we assigned a resource, pull the data into the scene
	if delivery_order and has_node("Sprite2D"):
		# If it ever has icon property
		name = "DeliveryZone_" + delivery_order.client
		if has_node("EditorLabel"):
			$EditorLabel.text = delivery_order.client

func _on_delivery_started(started_data: DeliveryData):
	if started_data == delivery_order:
		_set_active_state(true)

func _on_delivery_completed():
	_set_active_state(false)

func _set_active_state(state: bool):
	print("Setting state to: ", state)
	print("Data: ", delivery_order.address)
	is_active = state
	visible = true # Always visible, or dimmed
	monitoring = state
	monitorable = state
	
	# Visual cue
	$Sprite2D.modulate = Color(1, 1, 1) if state else Color(0.4, 0.4, 0.4)

func interact():
	# Trigger the completion in the global manager
	DeliveryManager.complete_delivery()
	player.interact_label.text = "Order delivered to " + delivery_order.client
