extends Node

@onready var collision = $StaticBody2D/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var open_sound = $OpenSound
@onready var close_sound = $CloseSound

var is_open = false
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
	if not is_open:
		open_sound.play()
	is_open = true
	collision.set_deferred("disabled", true)
	sprite.texture = door_open

func close():
	if is_open:
		close_sound.play()
	is_open = false
	collision.set_deferred("disabled", false)
	sprite.texture = door_close
