extends Character

const eye1 = preload("res://Assets/Characters/Player/Eye1.png")
const eye2 = preload("res://Assets/Characters/Player/Eye2.png")
const eye3 = preload("res://Assets/Characters/Player/Eye3.png")
const eye4 = preload("res://Assets/Characters/Player/Eye4.png")
const eye5 = preload("res://Assets/Characters/Player/Eye5.png")
const eye6 = preload("res://Assets/Characters/Player/Eye6.png")

@onready var eye: Sprite2D = $Body/Eye

var is_pressed_jump = false
var pressed_jump_time = 0.1

var current_step
var current_number

func _ready():
	super._ready()
	
	eye.hframes = body.hframes
	set_random()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_jump"):
		is_pressed_jump = true
		await get_tree().create_timer(pressed_jump_time).timeout
		
		is_pressed_jump = false

func _process(delta):
	super._process(delta)
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	eye.frame = body.frame

func play_animation(to_play: String):
	if base_animation.current_animation == to_play:
		return
	
	base_animation.play(to_play)

func set_random():
	var roll_data = GlobalController.RollDice()
	
	current_number = roll_data[0]
	eye.texture = get("eye" + str(roll_data[0]))
