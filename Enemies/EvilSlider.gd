extends Enemy

func _ready():
	setDirection(Vector2.RIGHT)
	pass

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass
