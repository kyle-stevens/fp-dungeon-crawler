extends StaticBody3D
#this is just to test some stuff

var type : Globals.EntityType = Globals.EntityType.ARCHITECTURE
var interact_mesg : String = "Press Return/Enter to interact"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(body):
	if $Torch != null:
		$Torch.queue_free()
	self.interact_mesg = ""
	
func attacked(direction):
	if $Torch != null:
		$Torch.queue_free()
	
