extends State

@onready var stats: PlayerStats

@export var falling: State
@export var idle: State

func enter() -> void:
	# snapshot movement as momentum for jump
	parent.momentum = parent.get_direction_from_input()
	stats = parent.player_stats
	parent.velocity.y += stats.jump_velocity
	parent.animation_tree.travel("jump_start", parent.ANIM_BLEND_SPEED)
	pass

func exit() -> void:
	pass

func physics_process(_delta: float) -> State:
	# Check if on floor and not moving up/down
	if parent.is_on_floor() and parent.velocity.y == 0.0:
		return idle
	# if Y becomes negative (falling down) return falling
	elif parent.velocity.y < 0.0:
		return falling
	else:
		# jump using momentum snapshot
		parent.move_character(parent.momentum)
		return null
