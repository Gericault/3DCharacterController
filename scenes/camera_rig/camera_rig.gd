extends SpringArm3D

## whatever position is set in editor within player scene is used as offset
@onready var INITIAL_POSITION_OFFSET = position

@onready var camera: Camera3D = $Camera3D

@export var turn_rate: float = 200.0
@export var mouse_sensitivity: float = 0.12
@export var target: CharacterBody3D

@export_group("kickback")
@export var enable_kickback : bool = true
var _screen_shake_tween : Tween
const MAX_SCREEN_SHAKE : float = 0.5
const MIN_SCREEN_SHAKE : float = 0.05

var mouse_input: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spring_length = camera.position.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		#here you can physics lerp to remove jitter
		position = target.position + INITIAL_POSITION_OFFSET

func trigger_landing_kickback(amount: float, time: float) -> void:
	if _screen_shake_tween:
		_screen_shake_tween.kill()
	
	_screen_shake_tween = create_tween()

	# anon function to reset camera to 0 in 0.1 seconds
	_screen_shake_tween.finished.connect(func():
		var reset_tween = create_tween()
		# Duration: 0.15 seconds (adjust for desired speed)
		reset_tween.tween_property(camera, "h_offset", 0.0, 0.10).set_ease(Tween.EASE_OUT)
		reset_tween.tween_property(camera, "rotation:x", 0.0, 0.10).set_ease(Tween.EASE_OUT)
	)
	
	_screen_shake_tween.tween_method(update_screen_shake.bind(amount), 0.0, -0.5, time).set_ease(Tween.EASE_OUT)

func update_screen_shake(alpha: float, amount:float) -> void:
	amount = remap(amount, 0.0, 1.0 , MIN_SCREEN_SHAKE, MAX_SCREEN_SHAKE)
	var current_shake_amount = amount * (1.0 -alpha)
	camera.h_offset = randf_range(-current_shake_amount, current_shake_amount)
	camera.rotation.x = sin(amount * alpha)
