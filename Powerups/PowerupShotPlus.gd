extends "res://Powerups/Powerup.gd"

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
@export var type : LEVEL_TYPE

func collected(body):
	if body.has_method("upgradeShot"):
		var level_type_list = LEVEL_TYPE.keys()
		body.upgradeShot(level_type_list[type])
		queue_free()
		return true
	return false
