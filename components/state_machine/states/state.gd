class_name State
extends Node

var parent: CharacterBody3D

## Called when the state is entered
func enter() -> void:
	pass
## Called when the state is exited
func exit() -> void:
	pass

func process(delta: float, input: InputPackage) -> String:
	return ""

func physics_process(delta: float, input: InputPackage) -> String:
	return ""