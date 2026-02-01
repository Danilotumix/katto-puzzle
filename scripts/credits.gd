extends Control

@onready var boton_volver = $BackButton

func _ready():
	boton_volver.mouse_entered.connect(_on_boton_mouse_entered)
	boton_volver.mouse_exited.connect(_on_boton_mouse_exited)
	
	boton_volver.modulate.a = 0
	create_tween().tween_property(boton_volver, "modulate:a", 1.0, 0.5)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main-menu.tscn")

func _on_boton_mouse_entered():
	create_tween().tween_property(boton_volver, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.1)
func _on_boton_mouse_exited():
	create_tween().tween_property(boton_volver, "modulate", Color(1, 1, 1, 1), 0.1)
