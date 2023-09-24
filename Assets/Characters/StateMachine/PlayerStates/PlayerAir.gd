extends State

var can_jump = true

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if owner.is_on_floor():
		state_machine.transition_to("PlayerGround")
		return
	
	owner.velocity.y += owner.GRAVITY * _delta
	if owner.velocity.y < 0 and can_jump and Input.is_action_pressed("ui_jump"):
		owner.velocity.y = -max(owner.JUMP_FORCE * 0.3, abs(owner.velocity.y))
		await get_tree().create_timer(0.3).timeout
		
		can_jump = false
	
	if abs(owner.input_vector.x) <= 0:
		owner.velocity.x = move_toward(owner.velocity.x, 0, owner.AIR_FRICTION * _delta)
	else:
		owner.velocity.x = move_toward(owner.velocity.x, owner.input_vector.x * owner.MOVE_SPEED, owner.AIR_ACCELERATION * _delta)

func enter(_msg := {}) -> void:
	owner.play_animation("air")

func exit() -> void:
	can_jump = true
