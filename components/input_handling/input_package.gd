class_name InputPackage
extends RefCounted

# Only job is to hold inputs
var movement_vector := Vector2.ZERO
var jump := false
var jump_held: bool = false
var sprint_held := false
var light_attack_pressed := false
var tab_pressed := false