class_name MainCamera extends Camera2D
## TODO: This is the camera that will follow the player

# Signals

# Enums

# Exports
@export var zoom_factor: float = 3.0
@export var target: Node2D

# Properties

# References

# Game Loop
func _process(_delta):
	zoom = Vector2(zoom_factor,zoom_factor)
	position = target.position

# Public Methods
func set_target(new_target: Node2D):
	target = new_target

# Private Methods

# Events

