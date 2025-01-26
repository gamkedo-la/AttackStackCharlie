extends Area2D

const COLLECTION_VFX = preload("res://Feedback VFX/collection_feedback.tscn")

const POWERUP_LIFETIME = 4
const FLASHING_TIME = 0.85 # total, not additive
const FLASH_TOGGLE_TIME = 0.1 # adjust to change flash rate

var elapsed_time = 0.0
var last_toggle_time = 0.0

var already_collected = false

func _ready():
	add_to_group("powerups")

func _process(delta):
	elapsed_time += delta
	if elapsed_time >= POWERUP_LIFETIME-FLASHING_TIME:
		if elapsed_time - last_toggle_time >= FLASH_TOGGLE_TIME:
			visible = !visible
			last_toggle_time = elapsed_time
	if elapsed_time >= POWERUP_LIFETIME:
		queue_free()

func _on_body_entered(body):
	if already_collected:
		return
	if collected(body):
		already_collected = true
		visible = false
		var collection_vfx = COLLECTION_VFX.instantiate()
		collection_vfx.position = global_position
		collection_vfx.z_index = -1
		get_parent().add_child(collection_vfx)
		PlayerVars.increase_stat("powerups_collected", 1, false)
	pass

func collected(body):
	print("this should be overriden by the powerup")
	return false # collision ignored

func force_safe_remove():
	queue_free()
