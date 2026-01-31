extends Node2D

# 1. Custom Signal to tell other objects (like a Door) what to do
signal button_state_changed(is_pressed: bool)

@onready var button_base = $StaticBody2D
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var image_up = preload("res://arte/mechanisms/Boton.png")
var image_down = preload("res://arte/mechanisms/BotonPresionado.png")

@export var target_door: Node2D

func _ready():
	# Connect the Area2D signals via code (or use the Editor Node tab)
	area.body_entered.connect(_on_body_changed)
	area.body_exited.connect(_on_body_changed)
	# Initialize visual
	sprite.texture = image_up

func _on_body_changed(_body):
	# 3. Check if anything valid is pressing the button
	var bodies = area.get_overlapping_bodies()
	
	var is_pressed = false
	for body in bodies:
		# Optional: Check for specific groups if you only want Crates/Players to trigger it
		if body.name != "TileMap" && body != button_base: # Ignore the floor itself!
			is_pressed = true
			break
			
	# 4. Update Visuals and Signal
	if is_pressed:
		sprite.texture = image_down
		button_state_changed.emit(true)
		target_door.open()
	else:
		sprite.texture = image_up
		button_state_changed.emit(false)
		target_door.close()
