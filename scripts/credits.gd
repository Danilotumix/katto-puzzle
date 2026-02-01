extends Control

@onready var container = $VBoxContainer

func _ready():
	
	container.position.y = get_viewport_rect().size.y
	
	var final_y = -container.get_combined_minimum_size().y
	
	
	var tween = create_tween()
	
	tween.tween_property(container, "position:y", final_y, 10.0).set_trans(Tween.TRANS_LINEAR)
	
	
	tween.finished.connect(_on_credits_finished)

func _on_credits_finished():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_credits_finished()
