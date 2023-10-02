extends Node2D

@onready var mesh_instance = $Unit
@onready var multi_mesh_instance = $MultiMeshInstance

var direction_list: Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]

var multi_mesh: MultiMesh
var mesh_list: Dictionary
var mesh_timer_list: Dictionary
var mesh_time = 1.2
var mesh_dir_list: Dictionary
var mesh_generated_num_list: Dictionary
var current_mesh_num: int = 0
var tween_color_list: Dictionary

var seed_timer: Timer
var seed_time = 0.01

func _ready():
	multi_mesh = multi_mesh_instance.multimesh
	multi_mesh.use_colors = true
	multi_mesh.instance_count = (get_viewport_rect().size.x + 10) * (get_viewport_rect().size.y + 10)
	multi_mesh.mesh = mesh_instance.mesh
	
	seed_timer = Timer.new()
	add_child(seed_timer)
	seed_timer.connect("timeout", set_seed)
	seed_timer.one_shot = true
	seed_timer.start(seed_time)

func set_seed():
	var seed_pos = Vector2.ZERO
	
	if randf_range(0, 1) < 0.5:
		if randf_range(0, 1) < 0.5:
			seed_pos = Vector2(0, randi_range(0, get_viewport_rect().size.y))
		else:
			seed_pos = Vector2(get_viewport_rect().size.x, randi_range(0, get_viewport_rect().size.y))
	else:
		if randf_range(0, 1) < 0.7:
			seed_pos = Vector2(randi_range(0, get_viewport_rect().size.x), 0)
		else:
			seed_pos = Vector2(randi_range(0, get_viewport_rect().size.x), get_viewport_rect().size.y)
	
	if mesh_list.has(seed_pos):
		set_seed()
		return
	else:
		initial_unit(seed_pos)
		seed_timer.start(seed_time * current_mesh_num)
		return

func seed_position(pos):
	pass

func initial_unit(pos: Vector2):
	var temp_timer = Timer.new()
	add_child(temp_timer)
	temp_timer.connect("timeout", generate_mesh.bind(pos))
	temp_timer.one_shot = true
	
	var t = Transform2D(0, pos)
	multi_mesh.set_instance_transform_2d(current_mesh_num, t)
	
	mesh_list[pos] = current_mesh_num
	mesh_timer_list[pos] = temp_timer
	mesh_dir_list[pos] = direction_list.duplicate()
	mesh_generated_num_list[pos] = 0
	tween_color_list[pos] = null
	
	for d in mesh_dir_list[pos]:
		if mesh_list.has(pos + d):
			mesh_dir_list[pos].erase(d)
	
	current_mesh_num += 1
	
	mesh_timer_list[pos].start(mesh_time)

func generate_mesh(pos: Vector2):
	var direction = generate_direction(pos)
	
	if direction:
		initial_unit(pos + direction)
		
		var p_position = GlobalController.player.get_screen_transform().get_origin()
		var dis_to_p = pos.distance_to(p_position)
		var rand_time = mesh_time * pow(mesh_generated_num_list[pos], 2)
		# * (log(dis_to_p / (get_viewport_rect().size.x / 2 )))
		mesh_timer_list[pos].start(randf_range(rand_time * 0.8, rand_time * 2.8))
	else:
		mesh_timer_list[pos].queue_free()
	
	generate_color(pos)

func generate_direction(pos: Vector2):
	if pos.x < 0 or pos.x > get_viewport_rect().size.x or pos.y < 0 or pos.y > get_viewport_rect().size.y or mesh_dir_list[pos].size() == 0:
		return
	
	mesh_generated_num_list[pos] += 1
	
	var p_position = GlobalController.player.get_screen_transform().get_origin()
	var direction = Vector2.ZERO
	
	if randf_range(0, 1) < 1.9 / mesh_generated_num_list[pos]:
		var direction_to_player = pos.direction_to(p_position)
		if direction_to_player.x > 0: direction_to_player.x = 1
		if direction_to_player.x < 0: direction_to_player.x = -1
		if direction_to_player.y > 0: direction_to_player.y = 1
		if direction_to_player.y < 0: direction_to_player.y = -1

		if direction_to_player.x == 0: direction = Vector2(0, direction_to_player.y)
		elif direction_to_player.y == 0: direction = Vector2(direction_to_player.x, 0)
		else: direction = Vector2(direction_to_player.x, 0) if randf_range(0, 1) < 0.5 else Vector2(0, direction_to_player.y)
		
#		if !mesh_dir_list[pos].has(direction):
#			return
	else:
		mesh_dir_list[pos].shuffle()
		direction = mesh_dir_list[pos][0]
	
	mesh_dir_list[pos].erase(direction)
	
	if mesh_list.has(pos + direction): return generate_direction(pos)
	else: return direction

func generate_color(pos: Vector2):
	var temp_color = Color.WHITE
	match mesh_dir_list[pos].size():
		0: temp_color = Color(0.3, 0.3, 0.3)
		1: temp_color = Color(0.5, 0.5, 0.5)
		2: temp_color = Color(0.7, 0.7, 0.7)
		3: temp_color = Color(0.9, 0.9, 0.9)
	multi_mesh.set_instance_color(mesh_list[pos], temp_color)
	
#	if tween_color_list[pos]:
#		tween_color_list[pos].kill()
#
#	tween_color_list[pos] = create_tween()
#	tween_color_list[pos].set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#	tween_color_list[pos].tween_property(multi_mesh.color_array, "pos", temp_color, 0.8)
