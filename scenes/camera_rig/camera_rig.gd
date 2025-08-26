extends SpringArm3D

## whatever position is set in editor within player scene is used as offset
@onready var INITIAL_POSITION_OFFSET = position

@onready var camera: Camera3D = $Camera3D

@export var turn_rate: float = 200.0
@export var mouse_sensitivity: float = 0.12
@export var target: CharacterBody3D

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
		