extends "res://Powerups/Powerup.gd"

func collected(body):
	if body.has_method("upgradeDrone"):
		body.upgradeDrone()
		queue_free()
		return true
	return false
