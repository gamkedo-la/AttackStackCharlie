extends Area2D

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
@export var type : LEVEL_TYPE

func _on_body_entered(body):
	if body.has_method("upgradeShot"):
		var level_type_list = LEVEL_TYPE.keys()
		body.upgradeShot(level_type_list[type])
		queue_free()
