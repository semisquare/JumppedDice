extends Node2D

const point_node = preload("res://Assets/Point/Point.tscn")

var points_list: Dictionary

#func _ready():
#	for i in 3:
#		var point: Point = point_node.instantiate()
#		add_child(point)
#		point.setup(points_list, Vector2.ZERO + Vector2(80 * (i - 1), 0))

func _process(delta):
	pass
