extends SpringArm3D

## whatever position is set in editor within player scene is used as offset
@onready var INITIAL_POSITION_OFFSET = position

@onready var camera: Camera3D = $Camera3D

@export var turn_rate: float = 200.0
@export var mouse_sensitivity: float = 0.12
@export var target: CharacterBody3D

@export_group("kickback")
@export var enable_kickback : bool = true
@export var decay: float = 3.0
@export var max_offset: Vector3 = Vector3(0.5, 0.5, 0.5)
@export var max_rotation: float = deg_to_rad(5.0)
@export var trauma_power: int = 3

var trauma: float = 0.0
var noise_time: float = 0.0
var noise = FastNoiseLite.new()
var original_camera_position: Vector3
var original_camera_rotation: Vector3


var mouse_input: Vector2 = Vector2()

func _ready() -> void:
	spring_length = camera.position.z

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.2

	original_camera_position = camera.position
	original_camera_rotation = camera.rotation

func _process(delta: float) -> void:
	var look_input := Input.get_vector("view_left", "view_right", "view_up", "view_down",)
	look_input *= turn_rate * delta
	look_input += mouse_input
	mouse_input = Vector2()
	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	rotation_degrees.x = clampf(rotation_degrees.x, -70, 40)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = -event.relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if target:
		position = target.position + INITIAL_POSITION_OFFSET


	if trauma > 0 and enable_kickback:
		trauma = max(trauma - decay * delta, 0.0)
		var shake_amount = pow(trauma, trauma_power)
		# Advance the noise time for smooth transition
		noise_time += delta * 25.0
		# Calculate the noise-based offset
		var noise_px = noise.get_noise_2d(1000.0, noise_time)
		var noise_py = noise.get_noise_2d(2000.0, noise_time)
		var noise_pz = noise.get_noise_2d(3000.0, noise_time)
		var noise_rx = noise.get_noise_2d(4000.0, noise_time)
		var noise_rz = noise.get_noise_2d(5000.0, noise_time)

		var offset_vector = Vector3(
			max_offset.x * noise_px,
			max_offset.y * noise_py,
			max_offset.z * noise_pz
		)
		camera.position = original_camera_position + offset_vector * shake_amount
		var shake_rotation = Vector3(
			max_rotation * shake_amount * noise_rx,
			0.0,
			max_rotation * shake_amount * noise_rz
		)
		camera.rotation.x = original_camera_position.x + shake_rotation.x
		camera.rotation.z = original_camera_rotation.z + shake_rotation.z

		if trauma == 0.0:
			camera.position = original_camera_position
			camera.rotation = original_camera_rotation

func add_trauma(amount: float, direction: Vector3):
	if not enable_kickback:
		return
	trauma = min(trauma + amount, 1.0)
	camera.position += direction * amount * 0.5
