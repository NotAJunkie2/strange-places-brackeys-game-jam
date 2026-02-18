extends Resource
class_name DeliveryData

@export var address: String = "Default Level"
@export_multiline var briefing: String
@export var client: String = "John Doe"
@export var pizza_type: Enums.PizzaType
@export var modifier: Array[Enums.PizzaModifier]
@export var texture: Texture2D
