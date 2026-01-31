extends CharacterBody2D

@export var animated_sprite : Sprite2D
@export var mask_sprite : Sprite2D
@export var collision_shape : CollisionShape2D
@export var label : Label

var mask_index: int = Constants.Mask.NONE

var masks = [mask_index]

var SPEED = 0
var JUMP_VELOCITY = 0
var GRAVITY = 0
var PUSH_FORCE = 0

var GORILLA_SPRITESHEET = preload("res://arte/masks/masks_ss.png")

func handleMaskChange():
	SPEED = 300.0
	JUMP_VELOCITY = -500.0
	GRAVITY = 1200
	PUSH_FORCE = 100
	var sprite_sheet = null
	if mask_index == Constants.Mask.GORILLA:
		PUSH_FORCE = PUSH_FORCE * 5
		sprite_sheet = GORILLA_SPRITESHEET
	if mask_index == Constants.Mask.BUNNY:
		JUMP_VELOCITY = JUMP_VELOCITY * 1.5
	if sprite_sheet != null:
		mask_sprite.visible = true
		mask_sprite.texture = sprite_sheet
		mask_sprite.hframes = 7  # Change this to the number of columns in your masks_ss.png
		mask_sprite.vframes = 1  # Change this to the number of rows
		mask_sprite.frame = 0    # Which specific face do you want? (0 = First, 1 = Second...)
	else:
		mask_sprite.visible = false

func _ready():
	handleMaskChange()

func _process(delta):
	if Input.is_action_just_pressed("ChangeMask"):
		while true:
			mask_index = mask_index + 1
			if mask_index > Constants.Mask.size() - 1:
				mask_index = 0
			if masks.has(mask_index):
				break;
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
		print(collision)
		# If the thing we hit is a RigidBody2D (like the box)
		if collision.get_collider() is RigidBody2D:
			# Calculate the direction: collision.get_normal() points OUT of the box towards the player.
			# We want to push opposite to that (INTO the box).
			var push_direction = -collision.get_normal()
			# Apply an impulse to the box to slide it
			# We use inertia/mass to make sure it moves naturally
			collision.get_collider().apply_central_impulse(push_direction * PUSH_FORCE)
		if collision.get_collider().name == "Pickup":
			pass
