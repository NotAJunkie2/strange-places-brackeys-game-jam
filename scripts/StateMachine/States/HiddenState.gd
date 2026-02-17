class_name HiddenState extends State

@onready var character: Character = owner


func enter(_previous: State) -> void:
	character.velocity = Vector2.ZERO
	character.modulate.a = 0.3


func process_physics(_delta: float) -> void:
	pass


func exit() -> void:
	character.modulate.a = 1.0
	character.set_collision_layer_value(1, true)
