extends "res://Powerups/Powerup.gd"
var invincibility_time: float = 5; # 5 seconds of invincibility

func collected(body):
	if body.has_method("upgradeInvincibility"):
		body.upgradeInvincibility(invincibility_time);
		queue_free();
		return true;
	return false
