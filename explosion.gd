extends CPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.emitting == false:
#		print("BOOM")
		queue_free()


func _on_damage_body_entered(body):
	if body.has_method("attacked"):
#			body.attacked("shot")
		pass #doing double damage, and hits player if close, might be worth keeping that
