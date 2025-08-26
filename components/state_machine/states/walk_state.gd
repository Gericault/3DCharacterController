extends State

#TOOD reference player stats and pass to states

@onready var stats: PlayerStats

@export var jump_state: State
@export var falling: State
@export var idle: State


var current_speed: float

func enter():
	stats = parent.player_stats

func input(event: InputEvent) -> State:
	#move to jump state
	if event.is_action_pressed("jump") and parent.is_on_floor() and not parent.is_falling():
		return jump_state

	return null

func physics_process(_delta: float) -> State:
	#check if falling
	if not parent.is_on_floor():
		return falling
			
	var direction = parent.get_direction_from_input()
	# if we are falling or landing wait for animations to finish before moving (but still deccelerate)
	if parent.is_falling():
		direction = Vector3.ZERO
	
	parent.move_character(direction)
	
	#check if we are not decelerating and not moving; set to idle or play appropiate animationw
	current_speed = parent.velocity.length()
	if current_speed == 0.0:
		return idle
	play_movement_animations(current_speed)
	return null



func play_movement_animations(speed):
	#play walking animations based on speed
	if speed > 3.5:
		parent.animation_tree.travel("freehand_run", parent.ANIM_BLEND_SPEED)
	elif speed > 0.0:
		parent.animation_tree.travel("freehand_walk", parent.ANIM_BLEND_SPEED)#, lerp(0.5, 1.75, current_speed / stats.speed))
