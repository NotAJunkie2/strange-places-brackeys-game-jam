extends Node


@onready var hurt_box: Area2D = $Area2D
@export var damage: int = 1


func _ready() -> void:
	hurt_box.body_entered.connect(_on_body_entered)
	hurt_box.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("character") and hurt_box.monitoring:
		body.damage(damage)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("character") and hurt_box.monitoring:
		print("did damage no leaving")
