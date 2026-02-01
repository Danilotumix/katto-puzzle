extends Node

@onready var maskLabel = $Label
@onready var player = $Katto
@onready var pause_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	maskLabel.text = Constants.Mask.keys()[player.mask_index]
