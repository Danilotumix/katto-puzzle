extends Sprite2D

@export var hover_speed = 2.0  # How fast it moves up/down
@export var hover_height = 20.0 # How far it moves (pixels)
@onready var start_y = position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (sin(time * hover_speed) * hover_height)
	# Apply the new position
	position.y = new_y
