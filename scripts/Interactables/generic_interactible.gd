class_name GenericInteractible extends Area2D
## Set collision layer to 4 (Interactables) and mask to 0.

@export var is_active: bool = true
var player: Character = null
var label_on_enter: String = "Press E to interact"

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("character") and is_active:
		(body as Character).interact_label.text = label_on_enter
		(body as Character).current_interactible = self
		player = body

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("character") and is_active:
		(body as Character).interact_label.text = ""
		(body as Character).current_interactible = null
		player = null

func interact():
	print("Interaction!")
	pass
