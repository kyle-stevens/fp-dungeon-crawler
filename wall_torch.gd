extends StaticBody3D
#this is just to test some stuff

var type : Globals.EntityType = Globals.EntityType.ARCHITECTURE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(body):
#	print("The Character is interacting with this wall")
#	print("Delete Torch")
	if $Torch != null:
		body.torch += 100.0
		$Torch.queue_free()
#	return("an object string, but will be more later")
	
func attacked(direction):
	if $Torch != null:
		$Torch.queue_free()
	
