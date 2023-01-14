extends RigidBody3D

var type : Globals.EntityType = Globals.EntityType.PLAYER

#North, West, South, East
var rotations = [deg_to_rad(0), deg_to_rad(90), deg_to_rad(180), deg_to_rad(270)]
var direction_facing : int
var directions = ["North", "West", "South", "East"]
var is_rotating : bool = false
var null_node = Node3D.new()
var objs_in_front : Node3D = self.null_node
var objs_behind : Node3D = self.null_node
var objs_left : Node3D = self.null_node
var objs_right : Node3D = self.null_node

#combat mechanics
var inventory = []
var equipped_weapon
var helmet
var chest
var shield
var shoulders
var health : int = 3
var ammunition : int = 6

var flashlight_on : bool = false
var torch_equipped : bool = false
var battery : float = 100.00
var torch : float = 100.00

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation = Vector3(0,0,0)
	$UserInterface/ColorRect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UserInterface/bullets.text = "Projectiles left - " + str(ammunition)
	$UserInterface/health.text = str(health) + " - Health"
	
	#This needs to be fixed
	if flashlight_on and self.battery > 0:
		pass
		#self.battery -= 0.05
#		print(self.battery)
	else:
		flashlight_on = false
	if torch_equipped and self.torch > 0:
		self.torch -= 0.025
#		print(self.torch)
	else:
		torch_equipped = false
	#need to rework the lighting system
	
	if Input.is_action_just_pressed("turn_left"):
		direction_facing += 1 # left turn
	if Input.is_action_just_pressed("turn_right"):
		direction_facing -= 1 # right turn
	
	if Input.is_action_just_pressed("walk") and self.objs_in_front == self.null_node and not self.is_rotating:
		if directions[direction_facing % 4] == "North":
			self.position += Vector3(0,0,-1)
		elif directions[direction_facing % 4] == "West":
			self.position += Vector3(-1,0,0)
		elif directions[direction_facing % 4] == "South":
			self.position += Vector3(0,0,1)
		elif directions[direction_facing % 4] == "East":
			self.position += Vector3(1,0,0)
	
# 	This needs some detection for behind the player	same for the strafing
	if Input.is_action_just_pressed("walk_back") and self.objs_behind == self.null_node and not self.is_rotating:
		if directions[direction_facing % 4] == "North":
			self.position += Vector3(0,0,1)
		elif directions[direction_facing % 4] == "West":
			self.position += Vector3(1,0,0)
		elif directions[direction_facing % 4] == "South":
			self.position += Vector3(0,0,-1)
		elif directions[direction_facing % 4] == "East":
			self.position += Vector3(-1,0,0)

	if Input.is_action_just_pressed("strafe_left") and self.objs_left == self.null_node and not self.is_rotating:
		if directions[direction_facing % 4] == "North":
			self.position += Vector3(-1,0,0)
		elif directions[direction_facing % 4] == "West":
			self.position += Vector3(0,0,1)
		elif directions[direction_facing % 4] == "South":
			self.position += Vector3(1,0,0)
		elif directions[direction_facing % 4] == "East":
			self.position += Vector3(0,0,-1)

	if Input.is_action_just_pressed("strafe_right") and self.objs_right == self.null_node and not self.is_rotating:
		if directions[direction_facing % 4] == "North":
			self.position += Vector3(1,0,0)
			#self.position = lerp(self.position, self.position + Vector3(0,0,-1), delta * 3)
		elif directions[direction_facing % 4] == "West":
			self.position += Vector3(0,0,-1)
		elif directions[direction_facing % 4] == "South":
			self.position += Vector3(-1,0,0)
		elif directions[direction_facing % 4] == "East":
			self.position += Vector3(0,0,1)
	
	self.rotation.y = lerp_angle(self.rotation.y, rotations[direction_facing % 4], delta * 10)
	#-zero not equal to zero bug
	var normalized_rotation_y = 2*PI + self.rotation.y if self.rotation.y < 0 else self.rotation.y
	
#	if (is_equal_approx(normalized_rotation_y, rotations[direction_facing % 4])) \
#	or (is_equal_approx(normalized_rotation_y, 2*PI)): # Fix the negative zero bug
#		self.is_rotating = false
#	else:
#		self.is_rotating = true	
	
	if Input.is_action_just_pressed("interact"):
		if self.objs_in_front.has_method("interact"):
			self.objs_in_front.interact(self)
	if Input.is_action_just_pressed("toggle_light"):
		#only going to have one, will wait for theme.
		if self.flashlight_on:
			self.flashlight_on = false
			self.torch_equipped = true
		elif self.torch_equipped:
			self.torch_equipped = false
		else:
			self.flashlight_on = true
		
	#attacks
	if Input.is_action_just_pressed("attack_up"):
		#play attack anim
		if self.objs_in_front.has_method("attacked"):
			self.objs_in_front.attacked("below")
	if Input.is_action_just_pressed("attack_down"):
		#play attack anim
		if self.objs_in_front.has_method("attacked"):
			self.objs_in_front.attacked("above")
	if Input.is_action_just_pressed("attack_left"):
		#play attack anim
		if self.objs_in_front.has_method("attacked"):
			self.objs_in_front.attacked("left")
	if Input.is_action_just_pressed("attack_right"):
		#play attack anim
		if self.objs_in_front.has_method("attacked"):
			self.objs_in_front.attacked("right")
	if Input.is_action_just_pressed("fire") and self.ammunition > 0: #still a little weird
		#fire projectile
		var shot = preload("res://shot.tscn").instantiate()
		shot.position = self.position
		shot.rotation = self.rotation
		shot.shooter = self
		get_tree().root.add_child(shot)
		self.ammunition -= 1
		
		
	if self.torch_equipped:
		var light : OmniLight3D = get_node("LightSource/Torch")
		light.visible = true
		$LightSource/Flashlight.visible = false
		light.light_energy += randf_range(-1,1) #very janky and flickery. Replace with a time based algo
		light.light_energy = clamp(light.light_energy, 0.95, 1.05)
	elif self.flashlight_on:
		$LightSource/Flashlight.visible = true
		$LightSource/Torch.visible = false
	else:
		$LightSource/Flashlight.visible = false
		$LightSource/Torch.visible = false

func attacked(direction):
	self.health -= 1
#	print(direction)
	$UserInterface/ColorRect.visible = true
	$UserInterface/Timer.start(0.15)

func _on_player_front_interaction_body_entered(body):
	self.objs_in_front = body
#	print("Intersect")
#	print(self.objs_in_front)
	if body.has_method("interact"):
		print("Press Return/Enter to Interact")
		#$UserInterface/popup.text = "Press Return/Enter to Interact" #needs to be revised
		#act more as an object passed that is queried each iteration

func _on_player_front_interaction_body_exited(body):
	if body == self.objs_in_front:
		self.objs_in_front = self.null_node
		$UserInterface/popup.text = ""

func _on_player_back_interaction_body_entered(body):
	self.objs_behind = body

func _on_player_back_interaction_body_exited(body):
	if body == self.objs_behind:
		self.objs_behind = self.null_node

func _on_player_left_interaction_body_entered(body):
	self.objs_left = body

func _on_player_left_interaction_body_exited(body):
	if body == self.objs_left:
		self.objs_left = self.null_node

func _on_player_right_interaction_body_entered(body):
	self.objs_right = body

func _on_player_right_interaction_body_exited(body):
	if body == self.objs_right:
		self.objs_right = self.null_node

func _on_timer_timeout():
	$UserInterface/ColorRect.visible = false
