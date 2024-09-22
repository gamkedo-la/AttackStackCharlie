extends Area2D

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
const COLLECTION_VFX = preload("res://Feedback VFX/collection_feedback.tscn")
@export var type : LEVEL_TYPE

func _on_body_entered(body):
	if body.has_method("upgradeShot"):
		
		#trigger collection feedback
		var collection_vfx = COLLECTION_VFX.instantiate()
		collection_vfx.position = global_position
		collection_vfx.z_index = -1
		get_parent().add_child(collection_vfx)
		print("not yet spawning new drone, stub of pickup")
		# var level_type_list = LEVEL_TYPE.keys()
		# body.upgradeShot(level_type_list[type])
		queue_free()
