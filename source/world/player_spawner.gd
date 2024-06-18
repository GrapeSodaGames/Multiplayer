class_name PlayerSpawner extends MultiplayerSpawner
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_actor_prefab: PackedScene = preload("res://source/world/actor/player_actor/player_actor.tscn")


# Properties

# References

# Game Loop
func _init():
	spawn_function = _spawn_player_actor

# Public Methods

# Private Methods

# Events
func _spawn_player_actor(info: PlayerInfo):
	var actor = _player_actor_prefab.instantiate()
	actor._info = info
	return actor
	
