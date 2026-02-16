extends Resource
class_name LevelData

@export_group("Level Info")
@export var level_name: String = "Default Level"
@export var level_scene: PackedScene
@export_multiline var description: String = "Standard level description"

@export_group("Order Details")
@export var client: String = "John Doe"
@export var pizza_type: Enums.PizzaType
@export var modifier: Enums.PizzaModifier
