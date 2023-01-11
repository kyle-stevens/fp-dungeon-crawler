extends Area3D

var type : Globals.EntityType = Globals.EntityType.PROJECTILE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	raycast.add_exception(body_to_ignore)
	self.position += self.basis.z * -0.1
	
#	print(self.position)
	
#	print(raycast.exclude_parent)
#	print(raycast.target_position)
#	print(self.position)


func _on_body_entered(body):
	if body.type == Globals.EntityType.ENEMY:
#		print("Hit Enemy")
		body.attacked("shot")
		queue_free()
	if body.type == Globals.EntityType.ARCHITECTURE:
#		print("Hit Wall")
		if body.has_method("attacked"):
			body.attacked("shot")
		queue_free()
#		print(self.position)
	
#	if body is StaticBody3D:
##		print("Hit Wall or Surface")
#		queue_free()


func _on_tree_exiting():
	print("exiting tree")
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.emitting = true
	explosion.position = self.position
	explosion.rotation = self.basis.z
	get_tree().root.add_child(explosion)



