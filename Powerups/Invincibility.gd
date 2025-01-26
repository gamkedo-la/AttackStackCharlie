extends "res://Powerups/Powerup.gd"
var invincibility_time: float = 5 # seconds of invincibility
var audio_player

func _ready():
	audio_player = $AudioStreamPlayer
	audio_player.connect("finished", Callable(self, "_on_AudioStreamPlayer_finished"))
	
func collected(body):
	if body.has_method("upgradeInvincibility"):
		body.upgradeInvincibility(invincibility_time);
		# queue_free();
		audio_player.play()
		return true;
	return false

func _on_AudioStreamPlayer_finished():
	queue_free()
