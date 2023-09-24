class_name Steps
extends Node2D

const step = preload("res://Assets/Step/Step.tscn")

var instigator: Map
var player: Character

var step_number
var interval

func _ready():
	pass

func setup(ins: Map, p: Character, sn):
	instigator = ins
	player = p
	step_number = sn
	
	for i in step_number:
		var temp_step: Step = step.instantiate()
		add_child(temp_step)
		
		interval = (get_viewport_rect().size.x + 2 * get_viewport_rect().size.x / step_number) / step_number
#		var interval = (get_viewport_rect().size.x) / step_number
		temp_step.global_position = Vector2(interval * (i - step_number / 2), 180) + player.global_position
		temp_step.setup(self, temp_step.global_position)

func _process(delta):
	sort_steps()

func sort_steps():
	if get_child_count() > 0:
		var first_step: Step = get_child(0)
		var second_step: Step = get_child(1)
		var second_last_step: Step = get_child(get_child_count() - 2)
		var last_step: Step = get_child(get_child_count() - 1)
		
		var screen_left = player.global_position.x - get_viewport_rect().size.x / 2
		var screen_right = player.global_position.x + get_viewport_rect().size.x / 2
		
		if second_step.global_position.x - screen_left > interval:
			last_step.global_position.x = first_step.global_position.x - interval
			last_step.set_random()
			move_child(last_step, 0)
			return
		
		if screen_right - second_last_step.global_position.x > interval:
			first_step.global_position.x = last_step.global_position.x + interval
			first_step.set_random()
			move_child(first_step, get_child_count() - 1)
			return
