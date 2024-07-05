extends Area2D

#webhook test

func _on_body_entered(body):
	if body.has_method("upgradeShot"):
		body.upgradeShot()
		queue_free()
