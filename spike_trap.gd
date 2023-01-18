extends Area3D

var type : Globals.EntityType = Globals.EntityType.TRAP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.type == Globals.EntityType.PLAYER:
		body.attacked("trap_death")
	elif body.type == Globals.EntityType.ENEMY:
		body.attacked("trap_death")
