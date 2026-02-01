extends Node

@onready var collision = $StaticBody2D/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var open_sound = $OpenSound
@onready var close_sound = $CloseSound

var pressed_count = 0
var door_open = preload("res://arte/mechanisms/PuertaAbierta.png")
var door_close = preload("res://arte/mechanisms/PuertaCerrada.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_state_changed(is_pressed):
	if is_pressed:
		open()
	else:
		close()

func open():
	if is_closed():
		open_sound.play()
		collision.set_deferred("disabled", true)
		sprite.texture = door_open
	pressed_count += 1

func close():
	if pressed_count < 0:
		pressed_count = 0
	if is_open() and pressed_count < 2:
		close_sound.play()
		collision.set_deferred("disabled", false)
		sprite.texture = door_close
	pressed_count -= 1

func is_open():
	return pressed_count > 0

func is_closed():
	return pressed_count <= 0
