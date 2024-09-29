extends Area2D

const COLLECTION_VFX = preload("res://Feedback VFX/collection_feedback.tscn")

func _ready():
	# to do: set up timer to flash and vanish
	pass

func _on_body_entered(body):
	if collected(body):
		var collection_vfx = COLLECTION_VFX.instantiate()
		collection_vfx.position = global_position
		collection_vfx.z_index = -1
		get_parent().add_child(collection_vfx)
	pass

func collected(body):
	print("this should be overriden by the powerup")
	return false # collision ignored
