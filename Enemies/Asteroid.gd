extends CharacterBody2D

var rotation_speed = 90
@export var speed: float = 100.0
#@export var detection_range: float = 200.0

@export var player: Node2D
func _ready():
	var sprite = $AnimatedSprite2D

func _process(delta):
	rotation_degrees += rotation_speed * delta
	position.x += speed * delta
	#
	#if position.x > get_viewport_rect().size.x:
		#respawn_asteroid()
#
#func respawn_asteroid():
	##var current_animation = self.animation
	##var frame_size = $AnimatedSprite2D.frames.get_frame_texture(current_animation,0).get_size()
	##
	##position.x = -frame_size.x
	##position.y = randf_range(0,get_viewport_rect().size.y - frame_size.y)
	#
	#
	#
	#
