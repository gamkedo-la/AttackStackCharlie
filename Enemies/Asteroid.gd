extends CharacterBody2D

var rotation_speed = 90
@export var speed: float = 100.0
@export var detection_range: float = 200.0

@export var player: Node2D
func _ready():
	player = get_tree().get_root().get_node("MainPlay/Playerdrone")

func _process(delta):
	rotation_degrees += rotation_speed * delta
	
	if player: 
		var dir_to_player = player.global_position - global_position
		var dis_to_player = dir_to_player.length()
		
		if dis_to_player <= detection_range:
			move_towards_player(dir_to_player.normalized())
			
func move_towards_player(direction: Vector2):
	velocity = direction * speed
	move_and_slide()
