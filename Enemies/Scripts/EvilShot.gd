extends "res://Enemies/Scripts/Enemy.gd"

@export var speed: float = 200.0

var shot_sounds = [
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_01.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_02.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_03.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_04.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_05.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_06.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_07.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_08.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_09.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_EnemyWeapon_Basic_Fire_10.wav")
]

func _ready():
	super._ready() # run the parent enemy init
	var audio_player = $AudioStreamPlayer
	audio_player.stream = shot_sounds[randi() % shot_sounds.size()]
	audio_player.play()
	isJustAShot = true
	pass

func _process(delta):
	moveDir = Vector2(speed, 0).rotated(rotation)
	position += moveDir * delta
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
