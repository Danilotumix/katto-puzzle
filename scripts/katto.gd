extends CharacterBody2D

@export var animated_sprite : Sprite2D
@export var collision_shape : CollisionShape2D
@export var label : Label

var mask_index: int = Constants.Mask.NONE

var SPEED = 0
var JUMP_VELOCITY = 0
var GRAVITY = 0
var PUSH_FORCE = 0

func handleMaskChange():
	SPEED = 300.0
	JUMP_VELOCITY = -400.0
	GRAVITY = 1200
	PUSH_FORCE = 100
	if mask_index == Constants.Mask.GORILLA:
		PUSH_FORCE = PUSH_FORCE * 5
	if mask_index == Constants.Mask.BUNNY:
		JUMP_VELOCITY = JUMP_VELOCITY * 1.5

func _ready():
	handleMaskChange()

func _process(delta):
	if Input.is_action_just_pressed("ChangeMask"):
		mask_index = mask_index + 1
		if mask_index > Constants.Mask.size() - 1:
			mask_index = 0
		handleMaskChange()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var is_crouching = false
	if Input.is_action_pressed("Crouch") and is_on_floor():
		is_crouching = true
		collision_shape.scale.y = 0.5 
	else:
		collision_shape.scale.y = 1.0

	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = (direction < 0)
		#_play_animation(is_crouching, true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#_play_animation(is_crouching, false)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		# If the thing we hit is a RigidBody2D (like the box)
		if collision.get_collider() is RigidBody2D:
			# Calculate the direction: collision.get_normal() points OUT of the box towards the player.
			# We want to push opposite to that (INTO the box).
			var push_direction = -collision.get_normal()
			# Apply an impulse to the box to slide it
			# We use inertia/mass to make sure it moves naturally
			collision.get_collider().apply_central_impulse(push_direction * PUSH_FORCE)
