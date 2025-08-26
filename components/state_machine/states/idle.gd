extends State

@export var jump_state: State
@export var walk_state: State
@export var falling: State

func enter():
	parent.animation_tree.travel("freehand_idle", parent.ANIM_BLEND_SPEED)

func input(event: InputEvent) -> State:
	#move to jump state
		if event.is_action_pressed("jump") and parent.is_on_floor() and not parent.is_falling():
			return jump_state
		return null

func physics_process(_delta: float) -> State:
	#check is falling
	if not parent.is_on_floor():
		return falling
	#check if falling/landing animations
	if parent.is_falling():
		return null
	#check if player wants to move and return move state
	var movement_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if movement_direction:
		return walk_state
	return null
