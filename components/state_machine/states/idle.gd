extends State

@export var state_machine: StateMachine

func enter():
	parent.animation_tree.travel("freehand_idle", parent.ANIM_BLEND_SPEED)

func physics_process(_delta: float, input: InputPackage) -> String:
	if not parent.is_on_floor():
		return "falling"

	if input.jump:
		return "jumping"

	#check if player wants to move and return move state
	if input.movement_vector:
		return "walking"
	return ""
