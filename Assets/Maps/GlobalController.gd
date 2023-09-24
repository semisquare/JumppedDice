extends Node

func _ready():
	seed(int(Time.get_unix_time_from_system()))

func _process(delta):
	pass

func RollDice():
	var rand_number = randi_range(1, 6)
	var rand_color: Color
	match rand_number:
		1:
			rand_color = Color.WHITE
		2:
			rand_color = Color.SEA_GREEN
		3:
			rand_color = Color.STEEL_BLUE
		4:
			rand_color = Color.MEDIUM_PURPLE
		5:
			rand_color = Color.CORAL
		6:
			rand_color = Color.GOLD
	
	return [rand_number, rand_color]
