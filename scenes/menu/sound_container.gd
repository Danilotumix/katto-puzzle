extends MarginContainer

@export var audio_player : AudioStreamPlayer2D
@export var music_button : Button

@export var icon_music_on : Texture2D
@export var icon_music_off : Texture2D

var is_music_playing = true

func _ready():
	if audio_player and !audio_player.playing:
		audio_player.play()
	
	if music_button:
		music_button.pressed.connect(_on_music_button_pressed)

func _on_music_button_pressed():
	if audio_player:
		is_music_playing = !is_music_playing
		audio_player.stream_paused = !is_music_playing
		
		music_button.icon = icon_music_on if is_music_playing else icon_music_off
