extends Area2D

const COLLECTION_VFX = preload("res://Feedback VFX/collection_feedback.tscn")

func _on_body_entered(body):
	if body.has_method("upgradeDrone"):
		var collection_vfx = COLLECTION_VFX.instantiate()
		collection_vfx.position = global_position
		collection_vfx.z_index = -1
		get_parent().add_child(collection_vfx)
		body.upgradeDrone()
		queue_free()
