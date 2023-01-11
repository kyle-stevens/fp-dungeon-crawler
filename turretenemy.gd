extends RigidBody3D
#need to rework as a body3d
var type : Globals.EntityType = Globals.EntityType.ENEMY

@export var target_body : PhysicsBody3D
@onready var sprite : Sprite3D = get_node("Sprite3D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.look_at(self.target_body.position, Vector3.UP)
	print((self.target_body.position - self.position).normalized().y)
	self.rotation.y = (self.target_body.position - self.position).normalized().y
#	print(self.rotation)

func attacked(direction):
	queue_free()
		



func _on_timer_timeout():
	#fire projectile
	var shot = preload("res://shot.tscn").instantiate()
	var spawnPoint : Node3D = get_node("EnemyTurret")
	shot.position = spawnPoint.global_position
	#print(shot.position)
	shot.rotation = Vector3(0,0,0)
	get_tree().root.add_child(shot)
	#This is not working properly, needs more work
