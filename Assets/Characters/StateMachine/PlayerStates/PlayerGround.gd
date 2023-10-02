extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if !owner.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	
	if owner.is_pressed_jump and owner.character_data.stamina >= owner.character_data.consume_stamina:
		owner.velocity.y = -owner.JUMP_FORCE
		owner.character_data.stamina -= owner.character_data.consume_stamina
	
	if abs(owner.input_vector.x) <= 0:
		owner.velocity.x = move_toward(owner.velocity.x, 0, owner.MOVE_FRICTION * _delta)
	else:
		owner.velocity.x = move_toward(owner.velocity.x, owner.input_vector.x * owner.MOVE_SPEED, owner.MOVE_ACCELERATION * _delta)
	
	if abs(owner.velocity.x) <= 0:
		owner.play_animation("idle")
	else:
		owner.play_animation("run")

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
