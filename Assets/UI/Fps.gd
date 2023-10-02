extends Label

func _ready():
	scale *= 0.2 

func _process(delta):
	text = "FPS: " + str(Engine.get_frames_per_second())
