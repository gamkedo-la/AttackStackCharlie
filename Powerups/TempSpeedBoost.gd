extends "res://Powerups/Powerup.gd"
var speedboost_time: float = 3;

func collected(body):
	if body.has_method("upgradeTempSpeedBoost"):
		body.upgradeTempSpeedBoost(speedboost_time);
		var audio_player = $AudioStreamPlayer
		audio_player.play()
		# queue_free(); # waiting for sound to finish
		return true;
	return false

func _on_audio_stream_player_finished():
	queue_free() 
