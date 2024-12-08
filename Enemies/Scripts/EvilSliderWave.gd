extends "res://Enemies/Scripts/Enemy.gd"

const WAVE_SLIDER_SPEED = 130.0
var base_angle
var wave_phase
var wave_amp
var wave_freq

func _ready():
	super._ready() # run the parent enemy init
	base_angle = rotation
	#warning: not 100% certain I'm using these numbers in a way that fits their names, but they do affect stuff :D
	wave_phase = randf_range(-1.0,1.0)
	wave_freq = randf_range(0.5,2.5)
	wave_amp = randf_range(0.75,1.5)
	pass

func _process(delta):
	wave_phase += delta*wave_freq
	rotation = base_angle + sin(wave_phase)*wave_amp
	moveDir = Vector2(WAVE_SLIDER_SPEED, 0).rotated(rotation)
	position += moveDir * delta
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
