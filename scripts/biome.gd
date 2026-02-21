extends Area2D
class_name Biome

@export var biome_type: Enums.Biome = Enums.Biome.NORMAL

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		WorldState.current_biome = biome_type
		print("Entered biome: ", biome_type)
