extends RigidBody2D
class_name Box

@export var terminal_velocity = 500.0
@export var max_push_speed = 300.0

@export var ground_damp = 5.0 
@export var air_damp = 0.0

@onready var floor_checker = $RayCast2D
@onready var drag_box_sound = $DragBoxSound

var was_moving = false
var is_moving = false
var is_on_floor = false

func _process(delta):
	if floor_checker.is_colliding():
		# Optional: Check WHAT we are standing on
		var collider = floor_checker.get_collider()
		if collider.name != "Katto":
			is_on_floor = true
	else:
		is_on_floor = false

	if is_on_floor and snapped(linear_velocity.x, 0.01) != 0:
		if not is_moving:
			is_moving = true
	else:
		if is_moving:
			is_moving = false

	#if not was_moving and is_moving:
	#	drag_box_sound.play()
	#elif was_moving and not is_moving:
	#	drag_box_sound.stop()

	was_moving = is_moving

func _integrate_forces(state):
	# 2. Terminal Velocity (Vertical Max) - Keep this
	if state.linear_velocity.y > terminal_velocity:
		state.linear_velocity.y = terminal_velocity

	# 3. PUSH SPEED LIMIT (The Fix for Yeeting)
	# We clamp the X velocity between -max and +max
	state.linear_velocity.x = clamp(state.linear_velocity.x, -max_push_speed, max_push_speed)
