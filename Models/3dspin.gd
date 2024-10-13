extends Node3D

@export var spinX: int
@export var spinY: int
@export var spinZ: int

@export var spinRate: float = 0.1

func _process(delta):
	rotate(Vector3(spinX,spinY,spinZ), spinRate*delta)
	pass
