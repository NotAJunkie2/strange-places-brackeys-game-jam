@tool
extends GenericInteractible
class_name DeliveryZone


@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var character = owner.find_child("Character") as Character
@export var delivery_order: DeliveryData:
	set(value):
		delivery_order = value
		if not is_node_ready():
			await ready
		_update_visuals()

func _ready() -> void:
	super()
	if not Engine.is_editor_hint():
		_set_active_state(false)
		# Listen to the global manager
		DeliveryManager.delivery_started.connect(_on_delivery_started)
		DeliveryManager.delivery_completed.connect(_on_delivery_completed)

func _enter_tree() -> void:
	_update_visuals()

func _update_visuals():
	# Use 'get_node_or_null' to prevent errors in the editor console
	var sprite = get_node_or_null("Sprite2D")
	var label = get_node_or_null("EditorLabel")
	
	if delivery_order:
		# Update Name (Note: name sync in editor can be finicky)
		name = "DeliveryZone_" + delivery_order.client
		
		if sprite and delivery_order.texture:
			sprite.texture = delivery_order.texture
		
		if label:
			label.text = delivery_order.client

func _on_delivery_started(started_data: DeliveryData):
	if started_data == delivery_order:
		_set_active_state(true)
		if character:
			character.current_target = self

func _on_delivery_completed():
	_set_active_state(false)
	character.interact_label.text = "Order delivered!"
	character.current_target = owner.find_child("PizzaPlace")

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
	audioPlayer.play()
	DeliveryManager.complete_delivery()
