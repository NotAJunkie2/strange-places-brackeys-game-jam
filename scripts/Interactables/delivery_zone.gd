extends GenericInteractible

@export_group("Identity")
## The name of the client (Must match the DeliveryData resource)
@export var client_name: String = "Chill Joe"
## Toggle this if the client isn't home yet (e.g., hidden until a certain stage)
@export var is_active: bool = true
@export var required_stage: WorldState.DeliveryStage

@export var texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	super()
	sprite.texture = texture
	pass

func interact():
	if WorldState.current_stage == required_stage:
		if DeliveryManager.current_delivery != null:
			print("Delivery Successful!")
			DeliveryManager.end_delivery()
			WorldState.current_stage += 1 # This triggers the Gates!
			player.interact_label.text = "Success! Head back to the pizza place, delivery boy!"
		else:
			player.interact_label.text = "You don't have the pizza!"
