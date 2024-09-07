extends Area2D

var max_scale = 4
var growth_rate = 0.2
var active = true

func _ready():
	scale = Vector2(0.1, 0.1)
	self.connect("area_entered", Callable(self, "_on_Area2D_area_entered"))

func _process(delta):
	if scale.x < max_scale and active:
		scale += Vector2(growth_rate, growth_rate)
		update_collision_shape()
	else:
		queue_free()

func update_collision_shape():
	if $CollisionShape2D.shape is CircleShape2D:
		$CollisionShape2D.shape.radius = 10.0 * scale.x

func _on_Area2D_area_entered(area):
	# print("Area entered: ", area.name) 
	$AudioStreamPlayer.play()
	var areaParent = area.get_parent()
	if areaParent.is_in_group("enemies") and active:
		# print("Destroying enemy: ", areaParent.name)
		if areaParent.has_method("destroy"):
			areaParent.destroy()
		else:
			print("No destroy method found")

func deactivate():
	active = false
