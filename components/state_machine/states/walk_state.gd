extends State

@onready var stats: PlayerStats

@export var state_machine: StateMachine

var current_speed: float

func enter():
	stats = parent.player_stats

func physics_process(_delta: float, input: InputPackage) -> String:
	#check if falling
	if not parent.is_on_floor():
		return "falling"
	
	if input.jump and not parent.is_falling():
		return "jumping"

	var direction = parent.get_direction_from_input()
	# if we are falling or landing wait for animations to finish before moving (but still deccelerate)
	if parent.is_falling():
		#direction = Vector3.ZERO
		pass
	parent.move_character(direction)

	#check if we are not decelerating and not moving; set to idle or play appropiate animation
	current_speed = parent.velocity.length()
	if current_speed == 0.0:
		return "idling"
	play_movement_animations(current_speed)
	return ""

func play_movement_animations(speed):
	#play walking animations based on speed
	if speed > 3.5:
		parent.animation_tree.travel("freehand_run", parent.ANIM_BLEND_SPEED)
	elif speed > 0.0:
		parent.animation_tree.travel("freehand_walk", parent.ANIM_BLEND_SPEED)#, lerp(0.5, 1.75, current_speed / stats.speed))
