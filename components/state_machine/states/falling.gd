extends State

@onready var stats: PlayerStats

@export var state_machine: StateMachine

func enter() -> void:
	parent.animation_tree.travel("freehand_fall", parent.ANIM_BLEND_SPEED * 2)
	stats = parent.player_stats
	

func exit() -> void:
	parent.momentum = Vector3.ZERO

func physics_process(_delta: float, input: InputPackage) -> String:
	#keeping seperate to below if/else so I don't duplicate this signal
	if parent.is_on_floor():
		#signal landed
		pass

	if input.movement_vector and parent.is_on_floor():
		return "walking"
	elif parent.is_on_floor():
		return "idling"
	else:
		# stats.air_control allows a % control over airmovement, as well as 1/3 turnspeed
		var fall_momentum = (parent.momentum * (1.0 - stats.air_control)) + (parent.get_direction_from_input() * stats.air_control)
		# cheat and add more gravity on fall for less floaty physics
		parent.velocity += ((parent.get_gravity() * _delta) * 3)
		parent.move_character(fall_momentum, stats.turn_speed / 3)
		return ""
