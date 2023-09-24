class_name Character
extends CharacterBody2D

@export var displayed_name = ""
@export var furigana_name = ""
@export var avatar : Texture2D
@export_enum("Male", "Female") var gender = 0
@export var apparel = ""
@export var hairstyle = ""

const MOVE_SPEED = 60.0
const MOVE_ACCELERATION = 780.0
const MOVE_FRICTION = 600.0

const JUMP_FORCE = 240.0
const GRAVITY = 980.0
const AIR_ACCELERATION = 158.0
const AIR_FRICTION = 340.0


var direction = Vector2(1, 1)
var move_rotation = 0
var direction_rotation = 0

var input_vector = Vector2.ZERO

@onready var body: Sprite2D = $Body
@onready var base_animation: AnimationPlayer = $BaseAnimation
#@onready var base_animation_tree: AnimationTree = $BaseAnimationTree
#@onready var base_animation_state_machine = base_animation_tree.get("parameters/playback")

func _ready():
	pass

func _process(delta):
	if abs(velocity.x) > 0:
		if velocity.x > 0:
			body.scale.x = 1
		if velocity.x < 0:
			body.scale.x = -1

