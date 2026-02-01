extends AnimatedSprite2D

# Configurable variables
@export var hover_speed = 2.0  # How fast it moves up/down
@export var hover_height = 10.0 # How far it moves (pixels)
@export var mask : Constants.Mask

# We need to remember where we started so we don't drift away
@onready var start_y = position.y
@onready var pickup_sound = $"../PickupSound"

var is_playing_forward = true

func _ready():
	animation_finished.connect(_on_animation_finished)
	if mask == Constants.Mask.GORILLA:
		play("gorilla")
	elif mask == Constants.Mask.BUNNY:
		play("bunny")

func _on_animation_finished():
	# 1. Flip the horizontal state (True becomes False, False becomes True)
	flip_h = !flip_h

	# 2. Restart the animation
	var anim_name = animation
	var total_frames = sprite_frames.get_frame_count(anim_name)

	# 3. Toggle direction and Skip the first frame of the new direction
	if is_playing_forward:
		# --- SWITCHING TO REVERSE ---
		is_playing_forward = false
		# We just finished the last frame. 
		# We want to start playing BACKWARDS from the 2nd to last frame.
		frame = total_frames - 2 
		play_backwards(anim_name)
	else:
		# --- SWITCHING TO FORWARD ---
		is_playing_forward = true
		# We just finished frame 0.
		# We want to start playing FORWARD from frame 1.
		frame = 1
		play(anim_name)

func _process(delta):
	# Calculate the new Y offset using a sine wave based on time
	# Time.get_ticks_msec() gives us a constantly increasing number
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (sin(time * hover_speed) * hover_height)
	
	# Apply the new position
	position.y = new_y


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Katto":
		if not Global.masks.has(mask):
			Global.masks.append(mask)
		var parent = get_parent()
		parent.visible = false
		parent.set_deferred("disabled", true)
		pickup_sound.play()

		body.animation_lock = false

		if mask == Constants.Mask.GORILLA:
			body.play_animation("pickup_mask_gorilla")
		elif mask == Constants.Mask.BUNNY:
			body.play_animation("pickup_mask_bunny")
		elif mask == Constants.Mask.OWL:
			body.play_animation("pickup_mask_owl")

		body.animation_lock = true
		body.is_locked = true
		body.last_picked_mask = mask
		body.animated_sprite.animation_finished.connect(body.finish_mask_animation, CONNECT_ONE_SHOT)
