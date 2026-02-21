extends Node
class_name Bgm_player

@export_group("Audio")
@export var lerpDuration : float = 1

@onready var mainAudioPlayer : AudioStreamPlayer = $MainStreamPlayer
@onready var glitchedAudioPlayer : AudioStreamPlayer = $GlitchedStreamPlayer

func _on_toggleGlitched(toggleState : bool):
	if(toggleState == false):
		var volume = 0;
		while(volume > 80) :
			volume -= 1 * get_process_delta_time() / lerpDuration
			glitchedAudioPlayer.volume_db = volume
		glitchedAudioPlayer.stop()
	else:
		glitchedAudioPlayer.play()
		var volume = -80;
		while(volume < 0) :
			volume += 1 * get_process_delta_time() / lerpDuration
			glitchedAudioPlayer.volume_db = volume
	pass
	
func _stop_main_track() :
	mainAudioPlayer.stop()
	
func _start_main_track() :
	if(mainAudioPlayer.playing):
		return
	mainAudioPlayer.play()
