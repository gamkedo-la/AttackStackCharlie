extends "res://Powerups/Powerup.gd"

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
@export var type : LEVEL_TYPE
var audio_player

func _ready():
	audio_player = $AudioStreamPlayer
	audio_player.connect("finished", Callable(self, "_on_AudioStreamPlayer_finished"))

func collected(body):
	if body.has_method("upgradeShot"):
		var level_type_list = LEVEL_TYPE.keys()
		body.upgradeShot(level_type_list[type])
		# queue_free()
		audio_player.play()
		return true
	return false

func _on_AudioStreamPlayer_finished():
	queue_free()
