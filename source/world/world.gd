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
	_player_spawner.spawn()

# Public Methods

# Private Methods

# Events

