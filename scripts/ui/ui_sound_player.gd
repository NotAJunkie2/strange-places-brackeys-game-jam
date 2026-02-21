extends Node

var playback:AudioStreamPlaybackPolyphonic

@export var pressedAudio : AudioStream
@export var hoveredAudio : AudioStream

@export var buttonsToTarget : Array[Button]
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	for button in buttonsToTarget :
		_connectButton(button)

func _connectButton(node:Button) -> void:
	node.focus_entered.connect(_play_hover)
	node.button_down.connect(_play_pressed)


func _play_hover() -> void:
	audioPlayer.stream = hoveredAudio
	audioPlayer.play()


func _play_pressed() -> void:
	audioPlayer.stream = pressedAudio 
	audioPlayer.play()
