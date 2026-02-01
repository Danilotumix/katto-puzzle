extends CharacterBody2D

@export var animated_sprite : AnimatedSprite2D
@export var mask_sprite : Sprite2D
@export var collision_shape : CollisionShape2D
@export var label : Label

@onready var hold_position = $BoxMarker
@onready var pickup_ray = $PickupRay
@onready var head_collision = $Area2D

var mask_index: int = Constants.Mask.NONE
var held_object: RigidBody2D = null
var can_pick_metal_box = false

var masks = [mask_index]

var SPEED = 0
var JUMP_VELOCITY = 0
var GRAVITY = 0
var PUSH_FORCE = 0
var THROW_POWER = 0
var METAL_BOX_THROW_POWER = 0
var METAL_BOX_THROW_POWER_MULTIPLIER = 20

var GORILLA_SPRITESHEET = preload("res://arte/masks/masks_ss.png")

func handleMaskChange():
	SPEED = 300.0
	JUMP_VELOCITY = -500.0
	GRAVITY = 1200
	PUSH_FORCE = 100
	THROW_POWER = 100
	METAL_BOX_THROW_POWER = 0
	can_pick_metal_box = false;
	var sprite_sheet = null
	if mask_index == Constants.Mask.GORILLA:
		PUSH_FORCE = PUSH_FORCE * 5
		METAL_BOX_THROW_POWER = THROW_POWER * METAL_BOX_THROW_POWER_MULTIPLIER
		sprite_sheet = GORILLA_SPRITESHEET
		can_pick_metal_box = true
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
	animated_sprite.play("default")
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
	if Input.is_action_just_pressed("Pickup"):
		pass

func _physics_process(delta):
	if velocity.x != 0:
		pickup_ray.target_position.x = 50 * sign(velocity.x)

	if Input.is_action_just_pressed("Pickup"):
		if held_object == null:
			try_pickup()
		else:
			lay_down_object()

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

func try_pickup():
# 1. Check if the ray is actually hitting a Box
	if pickup_ray.is_colliding():
		var body = pickup_ray.get_collider()
		
		if body is RigidBody2D:
			if body is MetalBox and not can_pick_metal_box:
				return

			# 2. Save reference
			held_object = body

			# 3. Disable Physics (So it doesn't fall or collide while holding)
			held_object.freeze = true 

			for child in held_object.find_children("*", "CollisionShape2D"):
				child.set_deferred("disabled", true)

			# 5. Make it a child of the Player's "HoldPosition"
			# reparent(new_parent, keep_global_transform)
			held_object.reparent(hold_position)
			held_object.position = Vector2.ZERO # Snap to center of marker
			held_object.rotation = 0            # Reset rotation	pass

func lay_down_object():
	if held_object != null:
		var box = held_object
		held_object = null

		box.reparent(get_parent())
		box.freeze = false

		# FIX: Turn collisions back ON
		for child in box.find_children("*", "CollisionShape2D"):
			child.set_deferred("disabled", false)

			# Add a tiny delay so the box doesn't hit the player instantly? 
			# Actually, since you are throwing it, you might want to keep the player/box 
			# on different Collision Layers as mentioned before, which is cleaner than 
			# toggling shapes.

			var dir = Vector2(sign(pickup_ray.target_position.x), -0.5).normalized()

			if box is MetalBox:
				box.apply_central_impulse(dir * METAL_BOX_THROW_POWER)
			else:
				box.apply_central_impulse(dir * THROW_POWER)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Box or body is MetalBox:
		if body.linear_velocity.y < 0:
			return
		# The box is sitting on our head. We need to push it off.

		# 1. Decide which way to push (Left or Right?)
		# We push it in the direction the player is moving, or random if standing still.
		var push_dir = 1

		if velocity.x != 0:
			push_dir = sign(velocity.x)
		else:
			# If standing still, push away from the center of the box
			var direction_to_box = body.global_position.x - global_position.x
			push_dir = 1 if direction_to_box > 0 else -1

		# 2. Apply a sudden impulse to the box
		# We push it SIDEWAYS (X) and slightly UP (Y) to lift it off the friction

		var force = Vector2(0, -1)

		if body is MetalBox:
			force = Vector2(0, -1 * THROW_POWER * METAL_BOX_THROW_POWER_MULTIPLIER * 5)
		else:
			force = Vector2(0, -1 * THROW_POWER * 5)

		body.apply_central_impulse(force)
