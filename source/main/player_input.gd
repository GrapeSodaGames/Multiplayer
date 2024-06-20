class_name PlayerInput extends Node
## TODO: Document

# Signals

# Enums

# Exports
@export var _position := Vector2.ZERO
# Properties


# References

# Game Loop
func _process(_delta):
	if multiplayer == null:
		return
	if not get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	if Input.is_action_pressed("move_up"):
		_position.y -= 1
	if Input.is_action_pressed("move_down"):
		_position.y += 1
	if Input.is_action_pressed("move_left"):
		_position.x -= 1
	if Input.is_action_pressed("move_right"):
		_position.x += 1

# Public Methods

# Private Methods

# Events

