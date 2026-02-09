extends Node

@export var level_number : int

@onready var pause_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	Global.level = level_number
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
