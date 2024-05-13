class_name GSGGame extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References
var _player_info_prefab = preload("res://source/player_info.tscn")
@onready var _local_config: LocalConfig = get_node("LocalConfig")

# Properties

# Game Loop
func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	UI.request_update_local_player_ready.connect(_on_request_update_local_player_ready)
	UI.request_update_local_player_color.connect(_on_request_update_local_player_color)
	Log.dbg("Game Ready")


# Public Methods
func player_info() -> PlayerInfo:
	return Server.get_local_player()
	
func local_config():
	return _local_config
	

# Private Methods

# Events
func _on_server_connect_success():
	Log.info("Game received server connect success")
	_local_config.set_config_server_ip(Server.connection_manager().get_server_ip())
	if Server.is_host():
		var new_player: PlayerInfo = _player_info_prefab.instantiate()
		new_player.set_id(multiplayer.get_unique_id())
		Server.get_players().update(new_player)
	

func _on_request_update_local_player_color(color: Color):
	player_info().set_color(color)

func _on_request_update_local_player_ready(value: bool):
	Log.info("message received with value ", value)
	player_info().set_ready(value)
	
