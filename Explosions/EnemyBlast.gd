extends Area2D

@onready var particles = $CPUParticles2D

var max_scale = 7
var growth_rate = 0.1
var active = true
var blastDepth = 1
var hit_scale = 0.1

var boom_sounds = [
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_01.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_02.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_03.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_04.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_05.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_06.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_07.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_08.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_09.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_10.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_11.wav"),
	preload("res://Raw Source Files/AUDIO/SFX/Sx_Enemy_Status_Defeat_A_12.wav")
]

func _ready():
	particles.restart()
	var audio_player = $AudioStreamPlayer
	audio_player.stream = boom_sounds[randi() % boom_sounds.size()]
	audio_player.play()
	self.connect("area_entered", Callable(self, "_on_Area2D_area_entered"))

func _process(delta):
	if hit_scale < max_scale and active:
		hit_scale += growth_rate # *delta
		update_collision_shape()
	else:
		queue_free()

func update_collision_shape():
	if $CollisionShape2D.shape is CircleShape2D:
		$CollisionShape2D.shape.radius = 10.0 * hit_scale

func _on_Area2D_area_entered(area):
	# print("Area entered: ", area.name) 
	var areaParent = area.get_parent()
	if areaParent.is_in_group("enemies") and active:
		# print("Destroying enemy: ", areaParent.name)
		if areaParent.has_method("destroy"):
			areaParent.destroy(blastDepth+1)
			# print("blast called destroy - did it register signal?")
		else:
			print("No destroy method found")

func deactivate():
	active = false
