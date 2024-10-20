extends Area2D

const COLLECTION_VFX = preload("res://Feedback VFX/collection_feedback.tscn")

const POWERUP_LIFETIME = 1.75
const FLASHING_TIME = 0.75 # total, not additive
const FLASH_TOGGLE_TIME = 0.1 # adjust to change flash rate

var elapsed_time = 0.0
var last_toggle_time = 0.0

func _process(delta):
	elapsed_time += delta
	if elapsed_time >= POWERUP_LIFETIME-FLASHING_TIME:
		if elapsed_time - last_toggle_time >= FLASH_TOGGLE_TIME:
			visible = !visible
			last_toggle_time = elapsed_time
	if elapsed_time >= POWERUP_LIFETIME:
		queue_free()

func _on_body_entered(body):
	if collected(body):
		var collection_vfx = COLLECTION_VFX.instantiate()
		collection_vfx.position = global_position
		collection_vfx.z_index = -1
		get_parent().add_child(collection_vfx)
		PlayerVars.increase_stat("powerups_collected", 1, false)
	pass

func collected(body):
	print("this should be overriden by the powerup")
	return false # collision ignored
