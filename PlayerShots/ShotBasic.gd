extends Area2D
# based on code from tutorial at https://www.youtube.com/watch?v=AHK5aQ7xvH8

@export var sprite1_path: NodePath
@export var sprite2_path: NodePath
@export var sprite3_path: NodePath

@onready var sprite1 = get_node(sprite1_path) as Node2D
@onready var sprite2 = get_node(sprite2_path) as Node2D
@onready var sprite3 = get_node(sprite3_path) as Node2D

const SHOT_SPEED = 300
var timeAlive = 0.0
var moveDir = Vector2.ZERO;

func activateShot(useSprite: int, lifeSpan:float, direction: Vector2):
	add_to_group("shots")
	sprite1.visible = (useSprite == 0)
	sprite2.visible = (useSprite == 1)
	sprite3.visible = (useSprite == 2)
	timeAlive = lifeSpan
	moveDir = direction
	rotation = atan2(moveDir.y,moveDir.x)

func _physics_process(delta):
	position += moveDir * delta * SHOT_SPEED
	rotation = atan2(moveDir.y,moveDir.x)
	timeAlive -= delta
	if timeAlive < 0:
		queue_free()

func force_safe_remove():
	queue_free()

# func _on_area_entered(area):
# 	if area.is_in_group("hitbox"):
# 		queue_free()
