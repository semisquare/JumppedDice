extends TextureProgressBar

var data: CharacterData

var initial_color = Color.AQUAMARINE
var exhausted_color = Color.ORANGE_RED
var changed_color
var modulate_tween: Tween

func _ready():
	await owner.ready
	
	changed_color = initial_color
	self.self_modulate = Color(changed_color, 0)
	
	data = owner.character_data
	
	data.connect("changed_max_stamina", change_max_value)
	data.connect("changed_stamina", change_value)

	max_value = data.max_stamina
	value = data.stamina

func _process(delta):
	pass

func change_max_value(_value):
	max_value = _value

func change_value(_value):
	value = _value
	
	if value < owner.character_data.consume_stamina:
		changed_color = exhausted_color
	else:
		changed_color = initial_color
	
	if modulate_tween:
		modulate_tween.kill()
	
	if value < max_value:
		modulate_tween = create_tween()
		modulate_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		modulate_tween.tween_property(self, "self_modulate", Color(changed_color, 1), 0.1)
	else:
		modulate_tween = create_tween()
		modulate_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		modulate_tween.tween_property(self, "self_modulate", Color(changed_color, 0), 0.3)
