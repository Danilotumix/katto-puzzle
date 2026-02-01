extends CanvasLayer

@onready var botones = [$ResumeButton, $RestartButton, $QuitButton]

var initial_masks = Global.masks.duplicate(false)

func _ready():
	visible = false
	for btn in botones:
		btn.mouse_entered.connect(_on_boton_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_boton_mouse_exited.bind(btn))

func _input(event):
	if event.is_action_pressed("Pausa") or (event is InputEventKey and event.pressed and event.keycode == KEY_T):
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_resume_button_pressed():
	toggle_pause() 

func _on_restart_button_pressed():
	get_tree().paused = false
	Global.masks = initial_masks
	Global.mask_index = Constants.Mask.NONE
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/menu/main-menu.tscn")

func _on_boton_mouse_entered(btn):
	create_tween().tween_property(btn, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.1)

func _on_boton_mouse_exited(btn):
	create_tween().tween_property(btn, "modulate", Color(1, 1, 1, 1), 0.1)
