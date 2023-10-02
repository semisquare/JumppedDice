class_name CharacterData
extends Node

var max_health
var health

var mana

@export var max_stamina = 0:
	set(value):
		max_stamina = value
		emit_signal("changed_max_stamina", value)
var stamina = 0:
	set(value):
		stamina = min(value, max_stamina)
		emit_signal("changed_stamina", value)
@export var consume_stamina = 0.0
@export var recover_stamina = 0.0
signal changed_max_stamina
signal changed_stamina

func _ready():
	await owner.ready
	
	stamina = max_stamina

func _process(delta):
	if stamina < max_stamina and owner.is_on_floor():
		stamina += recover_stamina * delta
