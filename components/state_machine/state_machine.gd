class_name StateMachine
extends Node

@export var starting_state: State

var current_state: State

func init(parent: Player) -> void:
	# set the parent of all children to the parent of the state machine
	for child in get_children():
		child.parent = parent

	change_state(starting_state)

## Calls exit function on current state and moves to new state whilst calling enter function
func change_state(new_state: State) -> void:
	# call exit function on current state
	if current_state:
		current_state.exit()

	current_state = new_state
	#call enter function on new state
	current_state.enter()

## pass through functions for the parent to call, handling changes prn.
func physics_process(delta: float) -> State:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)
	return current_state

func input(event: InputEvent) -> State:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)
	return current_state

func process(delta: float) -> State:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
	return current_state
