extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://demo_map.tscn")


func _on_load_game_button_pressed():
	pass # Replace with function body.


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	self.queue_free() # not working quite right, closes scene, but leaves game executable open
