class_name Point
extends Sprite2D

var direction_list: Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]

var points_list: Dictionary

var point_timer: Timer
var point_time = 1.2

var generated_number = 0

func _ready():
	pass

func setup(pl, pos):
	points_list = pl
	position = pos
	points_list[global_position] = self
	
	point_timer = Timer.new()
	add_child(point_timer)
	point_timer.connect("timeout", generate_point)
	point_timer.one_shot = true
	point_timer.start(point_time)
	
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func generate_point():
	var direction = generate_direction()
	
	if direction:
		var point = self.duplicate()
		get_parent().add_child(point)
		point.setup(points_list, position + direction)
		
		var rand_time = point_time * 2 * generated_number
		point_timer.start(randf_range(rand_time * 0.8, rand_time * 1.8))
	else:
		point_timer.queue_free()
	
	match direction_list.size():
		0: self_modulate = Color(0.6, 0.6, 0.6)
		1: self_modulate = Color(0.7, 0.7, 0.7)
		2: self_modulate = Color(0.8, 0.8, 0.8)
		3: self_modulate = Color(0.9, 0.9, 0.9)

func generate_direction():
	generated_number += 1
	
	if global_position.x < 0 or global_position.x > get_viewport_rect().size.x or global_position.y < 0 or global_position.y > get_viewport_rect().size.y:
		return
	
	if direction_list.size() == 0:
		return
	
	var p_position = GlobalController.player.get_screen_transform().get_origin()
	var direction = Vector2.ZERO
	
	if randf_range(0, 1) < 0.9:
		var direction_to_player = global_position.direction_to(p_position)
		if direction_to_player.x > 0: direction_to_player.x = 1
		if direction_to_player.x < 0: direction_to_player.x = -1
		if direction_to_player.y > 0: direction_to_player.y = 1
		if direction_to_player.y < 0: direction_to_player.y = -1

		if direction_to_player.x == 0: direction = Vector2(0, direction_to_player.y)
		elif direction_to_player.y == 0: direction = Vector2(direction_to_player.x, 0)
		else: direction = Vector2(direction_to_player.x, 0) if randf_range(0, 1) < 0.5 else Vector2(0, direction_to_player.y)
	else:
		direction_list.shuffle()
		direction = direction_list.pop_front()
	
	direction_list.erase(direction)
	
#	var dir_p_to_p = p_position.direction_to(global_position)
#	var dir_p_to_s = p_position.direction_to(global_position + direction)
#	var dis_p_to_s = p_position.distance_to(global_position + direction)
#	var s_cos = dir_p_to_p.dot(dir_p_to_s)
#	var dis_s_to_l = dis_p_to_s * sin(acos(s_cos))
#	if randf_range(0, 1) < dis_s_to_l * 0.2:
#		return
	
	if points_list.has(global_position + direction): return generate_direction()
	else: return direction
