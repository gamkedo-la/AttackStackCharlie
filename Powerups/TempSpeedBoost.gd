extends "res://Powerups/Powerup.gd"
var speedboost_time: float = 3;

func collected(body):
	if body.has_method("upgradeTempSpeedBoost"):
		body.upgradeTempSpeedBoost(speedboost_time);
		queue_free();
		return true;
	return false
