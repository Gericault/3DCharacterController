extends CharacterBody3D
class_name Player

const ANIM_BLEND_SPEED: float = 0.2

@export var player_stats: PlayerStats
@export var state_machine: StateMachine
@export var input_handler: InputHandler

@export var camera: Node3D
@onready var animation_tree = $AnimationTree["parameters/playback"]

#used to calculate jumps within given paramters in stats - see projectile motion - f(x) = (ax*2) + bc + c
@onready var jump_velocity: float = ((2.0 * player_stats.jump_height) / player_stats.jump_time_to_peak)
@onready var jump_gravity: float = ((-2.0 * player_stats.jump_height) / (player_stats.jump_time_to_peak * player_stats.jump_time_to_peak))
@onready var fall_gravity: float = ((-2.0 * player_stats.jump_height) / (player_stats.jump_time_to_descent * player_stats.jump_time_to_descent))

## use to snapshot movement direction
var momentum: Vector3

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state_machine.init(self, input_handler)
	#connect landed signal from fall state to camera kickback function

# mouse is hidden during gameplay, toggled with tab key
func _input(event):
	if event.is_action_pressed("tab"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	velocity.y += get_jump_gravity() * delta
	
func get_jump_gravity() -> float:
	if not is_on_floor():
		return jump_gravity if velocity.y > 0.0 else fall_gravity
	return 0.0
	
func _process(delta: float) -> void:
	state_machine.process(delta)

## Turns player to face inputted direction lerp to turn_speed
func turn_to(directon_to_face: Vector3, turn_speed: float = -1.0) -> void:
	if turn_speed == -1.0:
		turn_speed = player_stats.turn_speed

	if directon_to_face:
		var yaw := atan2(-directon_to_face.x, -directon_to_face.z)
		yaw = lerp_angle(rotation.y, yaw, turn_speed)
		rotation.y = yaw

## returns true if animation is falling or landing
func is_falling() -> bool:
	if animation_tree.get_current_node() in ["freehand_fall", "landing_soft"]:
		return true
	return false

## Moves player based on Vector3 input and applies current velocity, turn speed defaults to player_stats value
func move_character(direction, turn_speed: float = -1.0) -> void:
	if direction:
		velocity.x = direction.x * player_stats.speed
		velocity.z = direction.z * player_stats.speed
	else:
		#when not moving, slow down to a halt
		velocity.x = move_toward(velocity.x, 0, player_stats.deceleration_rate)
		velocity.z = move_toward(velocity.z, 0, player_stats.deceleration_rate)

	turn_to(direction, turn_speed)
	move_and_slide()

## returns desired direction relative to camera
func get_direction_from_input() -> Vector3:
	var input_dir : Vector2 = input_handler.collect_inputs().movement_vector
	# make movement relative to camera and account for joystick sens
	var direction = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# normalise camera pitch so looking into ground/up doesn't adjust speed
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	return direction
