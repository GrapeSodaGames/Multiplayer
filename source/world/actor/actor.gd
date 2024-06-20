class_name Actor extends CharacterBody2D
## TODO: Document

# Signals

# Enums

# Exports

# Properties
var _info: PlayerInfo
# References

# Game Loop
func _process(delta):
	position = _info.get_pos()

# Public Methods
func setup(info: PlayerInfo):
	_info = info
	name = str(_info.player_name())

# Private Methods

# Events

