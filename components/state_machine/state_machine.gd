class_name StateMachine
extends Node

@export var starting_state: State

var current_state: State
var input_handler: InputHandler = null
var states_by_name = {}

func init(parent: Player, handler: InputHandler) -> void:
	# set the parent of all children to the parent of the state machine
	input_handler = handler
	for child in get_children():
		child.parent = parent
		states_by_name[child.name] = child
		
	change_state(starting_state.name)

## Calls exit function on current state and moves to new state whilst calling enter function
func change_state(new_state_name: String) -> void:
	var new_state: State = states_by_name.get(new_state_name)
	# call exit function on current state
	if current_state:
		current_state.exit()

	current_state = new_state
	#call enter function on new state
	print(current_state)
	current_state.enter()

## pass through functions for the parent to call, handling changes prn.
func physics_process(delta: float) -> String:
	var new_state = current_state.physics_process(delta, input_handler.collect_inputs())
	if new_state:
		change_state(new_state)
	return current_state.name

func process(delta: float) -> String:
	var new_state = current_state.process(delta, input_handler.collect_inputs())
	if new_state:
		change_state(new_state)
	return current_state.name
