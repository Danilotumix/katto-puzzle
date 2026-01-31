extends CharacterBody2D

@export var animated_sprite : AnimatedSprite2D
@export var collision_shape : CollisionShape2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_SPEED = 150.0
const GRAVITY = 1200

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var is_crouching = false
	if Input.is_action_pressed("crouch") and is_on_floor():
		is_crouching = true
		collision_shape.scale.y = 0.5 
	else:
		collision_shape.scale.y = 1.0

	var direction = Input.get_axis("move_left", "move_right")
	
	var current_speed = CROUCH_SPEED if is_crouching else SPEED

	if direction:
		velocity.x = direction * current_speed
		animated_sprite.flip_h = (direction < 0)
		#_play_animation(is_crouching, true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#_play_animation(is_crouching, false)

	move_and_slide()
