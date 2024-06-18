class_name World extends Node2D
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_actor_prefab: PackedScene = preload("res://source/world/actor/player_actor/player_actor.tscn")

# Properties


# References
@onready var _player_spawner: MultiplayerSpawner = %PlayerSpawner

# Game Loop
func _ready():
	for player in GameState.get_players().all():
		var actor = _player_actor_prefab.instantiate()
		actor.setup(player)
		_player_spawner.add_child.call_deferred(actor, true)

# Public Methods

# Private Methods

# Events

