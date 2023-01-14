extends RigidBody3D
#need to rework as a body3d
var type : Globals.EntityType = Globals.EntityType.ENEMY

@export var target_body : PhysicsBody3D
@onready var sprite : Sprite3D = get_node("Sprite3D")
@export var range : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite3D2.scale = Vector3(self.range, self.range, self.range) #will be a circular sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.look_at(self.target_body.position, Vector3.UP)
	#print((self.target_body.position - self.position).normalized().y)
	self.rotation.y = $Sprite3D.global_rotation.y
	print(self.position)
#	print($Sprite3D.global_rotation)
#	print(self.rotation)

func attacked(direction):
	queue_free()
	pass
		



func _on_timer_timeout():
	#fire projectile
	if (self.target_body.position).distance_to(self.position) < self.range:
		var shot = preload("res://shot.tscn").instantiate()
		var spawnPoint : Node3D = get_node("EnemyTurret")
		shot.position = spawnPoint.global_position
		shot.speed_multiplier = 1
		shot.shooter = self
		#print(shot.position)
		shot.rotation = self.rotation
		get_tree().root.add_child(shot)
		#This is not working properly, needs more work
