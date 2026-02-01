extends Control

func _ready():
	# Efecto de movimiento para el contenedor de botones
	var tween = create_tween().set_loops()
	tween.tween_property($VBoxContainer, "position:y", $VBoxContainer.position.y + 10, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($VBoxContainer, "position:y", $VBoxContainer.position.y, 2.0).set_trans(Tween.TRANS_SINE)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
