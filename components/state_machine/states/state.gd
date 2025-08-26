class_name State
extends Node

var parent: CharacterBody3D

## Called when the state is entered
func enter() -> void:
	pass
## Called when the state is exited
func exit() -> void:
	pass

func input(event: InputEvent) -> State:
	return null

func process(delta: float) -> State:
	return null

func physics_process(delta: float) -> State:
	return null