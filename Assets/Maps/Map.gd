class_name Map
extends Node2D

var player = preload("res://Assets/Characters/Player/Player.tscn")
var steps = preload("res://Assets/Step/Steps.tscn")

func _ready():
	var temp_player: Character = player.instantiate()
	add_child(temp_player)
	
	temp_player.global_position = Vector2(0, 0)
	
	var temp_steps: Steps = steps.instantiate()
	add_child(temp_steps)
	
	temp_steps.setup(self, temp_player, 13)

func _process(delta):
	pass
