class_name PlayerSpawner extends MultiplayerSpawner
## TODO: Document

# Signals

# Enums

# Exports

# Properties

# References

# Game Loop
func _init():
	spawn_function = _spawn_player_actor

# Public Methods

# Private Methods

# Events
func _spawn_player_actor(info: PlayerInfo):
	var actor = Actor.new(info)
	return actor
	
