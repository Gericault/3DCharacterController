class_name PlayerStats
extends Resource

const ANIM_BLEND_SPEED: float = 0.2

@export_group("movement_stats")
@export var speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var deceleration_rate: float = 0.5
#@export var camera: Node3D
@export var turn_speed: float = 0.25
@export var air_control: float = 0.2
#@export var animation: AnimationPlayer
