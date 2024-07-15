class_name World extends Node2D
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_actor_prefab: PackedScene = preload("res://source/world/actor/player_actor/player_actor.tscn")

# Properties


# References
@onready var _player_spawner: MultiplayerSpawner = %PlayerSpawner
@onready var _main_camera: MainCamera = %MainCamera

# Game Loop
func _ready():
	Log.info("Camera? ", _main_camera.name)
	for player: PlayerInfo in GameState.get_players().all():
		var actor = _player_actor_prefab.instantiate()
		actor.setup(player)
		if player.get_multiplayer_authority() == multiplayer.get_unique_id():
			_main_camera.set_target(actor)
		_player_spawner.add_child.call_deferred(actor, true)
		
		
			

# Public Methods

# Private Methods

# Events

