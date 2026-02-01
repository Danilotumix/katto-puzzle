extends Control

@onready var titulo = $TituloA
@onready var botones = [$PlayButton, $CreditButton, $QuitButton]

func _ready():
	var pos_final_titulo = titulo.position 
	titulo.position.y += 500               
	titulo.modulate.a = 0                  
	if titulo.has_method("set_frame"): titulo.frame = 0 
	
	for btn in botones:
		btn.modulate.a = 0
		btn.mouse_entered.connect(_on_boton_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_boton_mouse_exited.bind(btn))

		if btn.name == "PlayButton": btn.pressed.connect(_on_play_pressed)
		if btn.name == "CreditButton": btn.pressed.connect(_on_credits_pressed)
		if btn.name == "QuitButton": btn.pressed.connect(_on_quit_pressed)

	var tween_entrada = create_tween()
	
	tween_entrada.set_parallel(true)
	tween_entrada.tween_property(titulo, "position", pos_final_titulo, 1.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_entrada.tween_property(titulo, "modulate:a", 1.0, 0.8)
	
	tween_entrada.chain().set_parallel(true)
	for btn in botones:
		tween_entrada.tween_property(btn, "modulate:a", 1.0, 0.5)
	
	tween_entrada.chain().tween_callback(func(): if titulo.has_method("play"): titulo.play("default"))
	tween_entrada.tween_callback(_iniciar_movimientos_infinitos)

func _iniciar_movimientos_infinitos():
	var tween_titulo = create_tween().set_loops()
	tween_titulo.tween_property(titulo, "position:y", titulo.position.y + 10, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_titulo.tween_property(titulo, "position:y", titulo.position.y, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	for i in range(botones.size()):
		var btn = botones[i]
		var pos_y_base = btn.position.y
		var tw_b = create_tween().set_loops()
		tw_b.tween_interval(i * 0.2)
		tw_b.tween_property(btn, "position:y", pos_y_base + 8, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tw_b.tween_property(btn, "position:y", pos_y_base, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_boton_mouse_entered(btn):
	create_tween().tween_property(btn, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.1)

func _on_boton_mouse_exited(btn):
	create_tween().tween_property(btn, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")

func _on_quit_pressed():
	get_tree().quit()
