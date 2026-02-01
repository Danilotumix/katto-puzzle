extends Box
class_name MetalBox

func _integrate_forces(state):
	# 2. Terminal Velocity (Vertical Max) - Keep this
	if state.linear_velocity.y > terminal_velocity:
		state.linear_velocity.y = terminal_velocity

	# 3. PUSH SPEED LIMIT (The Fix for Yeeting)
	# We clamp the X velocity between -max and +max
	state.linear_velocity.x = clamp(state.linear_velocity.x, -max_push_speed, max_push_speed)
