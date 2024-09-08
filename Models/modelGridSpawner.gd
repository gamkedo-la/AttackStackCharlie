extends Node3D

@export var mesh: PackedScene

@export var xSpacing: float = 1.0
@export var ySpacing: float = 1.0
@export var xCount: int = 5
@export var yCount: int = 5
@export var scaleSpawned: float = 1.0

func _ready():
	for i in range(xCount):
		for j in range(yCount):
			var position = Vector3(i * xSpacing, 0, j * ySpacing)
			var mesh_instance = mesh.instantiate()
			mesh_instance.transform.origin = position
			# seems longwinded, but the older .scale mode doesn't seem to work in 4.2?
			mesh_instance.transform.basis = mesh_instance.transform.basis.scaled(Vector3(scaleSpawned,scaleSpawned,scaleSpawned))
			add_child(mesh_instance)
