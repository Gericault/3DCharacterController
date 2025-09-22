class_name InputHandler
extends Node

## collects inputs into a nice package that can be accessed by states
func collect_inputs() -> InputPackage:
	var package = InputPackage.new()

	package.movement_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	package.jump = Input.is_action_just_pressed("jump")
	package.jump_held = Input.is_action_pressed("jump")
	#package.sprint_held = Input.is_action_pressed("sprint")
	#package.light_attack_pressed = Input.is_action_just_pressed("light_attack")
	package.tab_pressed = Input.is_action_just_pressed("tab")

	return package
