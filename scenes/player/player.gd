extends CharacterBody3D
class_name Player

const ANIM_BLEND_SPEED: float = 0.2

@export var player_stats: PlayerStats
@export var state_machine: StateMachine

@export var camera: Node3D
@onready var animation_tree = $AnimationTree["parameters/playback"]

var current_speed : float
## use to snapshot movement direction
var momentum: Vector3

#TODO move current_speed and movement into a movement_controller node within statemachine
 
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state_machine.init(self)

func _input(event):
	if event.is_action_pressed("tab"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)

func _physics_process(delta: float) -> void:
	print(state_machine.current_state)
	state_machine.physics_process(delta)
	velocity += get_gravity() * delta
	
	
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

	#parent.move_and_slide()
	turn_to(direction, turn_speed)
	move_and_slide()

## returns desired direction relative to camera
func get_direction_from_input() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# make movement relative to camera and account for joystick sens
	var direction = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# normalise camera pitch so looking into ground/up doesn't adjust speed
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	return direction