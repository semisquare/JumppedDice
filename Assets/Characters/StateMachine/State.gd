class_name State
extends Node

var state_machine: StateMachine = null

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass

static func DRollDice() -> int:
	var rand_number = randi_range(1, 6)
	
	return rand_number
