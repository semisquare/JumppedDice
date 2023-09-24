class_name Step
extends CharacterBody2D

@onready var body: NinePatchRect = $Body
@onready var collision: CollisionShape2D = $Collision
@onready var player_detector: Area2D = $PlayerDetector

var instigator: Node2D
var player: Character

var initial_position
var g_offset
var is_detected

func _ready():
	player_detector.connect("body_entered", player_entered)
	player_detector.connect("body_exited", player_exited)
	
	set_random()

func setup(i, pos):
	instigator = i
	player = i.player
	
	initial_position = pos

func set_random():
	var roll_data = GlobalController.RollDice()
	
	body.size.y = roll_data[0] * 8 + 64
	body.position.y = -body.size.y
	body.self_modulate = roll_data[1]
	
	var r_shape = RectangleShape2D.new()
	r_shape.size = Vector2(26, body.size.y)
	collision.shape = r_shape
	collision.position.y = -body.size.y / 2
	
	player_detector.position.y = -body.size.y - 1
	
	g_offset = Vector2(0, body.size.y * 0.05)

func _physics_process(delta):
	var speed_y = 0
	
	if is_detected:
		var offset_position = initial_position + g_offset
		if global_position.distance_to(offset_position) > 0.1:
			speed_y = global_position.direction_to(offset_position).y * global_position.distance_to(offset_position) * 80
	else:
		speed_y = global_position.direction_to(initial_position).y * global_position.distance_to(initial_position) * 80
	
	velocity.y = move_toward(velocity.y, speed_y, 1600 * delta)
	
	move_and_slide()

func player_entered(d_player):
	if d_player.get_collision_layer_value(2):
		is_detected = true
		velocity.y = 40
		
		if d_player.current_step != self:
#			if d_player.current_step:
#				var past_step: Step = d_player.current_step
#
#				var tween = create_tween()
#				tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
#				tween.tween_property(past_step, "modulate", Color(1,1,1,0), 0.4)
			
			d_player.set_random()
			d_player.current_step = self

func player_exited(d_player):
	if d_player.get_collision_layer_value(2):
		is_detected = false

