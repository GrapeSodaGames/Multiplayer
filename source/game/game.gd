class_name GSGGame extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References
var _player_info = PlayerInfo.new()
@onready var _local_config: LocalConfig = get_node("LocalConfig")

# Properties

# Game Loop
func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	UI.request_update_local_player_ready.connect(_on_request_update_local_player_ready)
	UI.request_update_local_player_color.connect(_on_request_update_local_player_color)
	Log.dbg("Game Ready")

func _process(delta):
	if Server.is_peer_connected():
		_sync_player_from_server()


# Public Methods
func player_info() -> PlayerInfo:
	return _player_info
	
func local_config():
	return _local_config

# Private Methods
func _sync_player_from_server():
	if Server.get_players().size() > 0:
		var server_player:PlayerInfo = Server.get_local_player()
		_player_info = server_player

# Events
func _on_server_connect_success():
	Log.info("Game received server connect success")
	_local_config.set_config_server_ip(Server.connection_manager().get_server_ip())

func _on_request_update_local_player_color(color: Color):
	player_info().set_color(color)
	Server.sync_local_players()

func _on_request_update_local_player_ready(value: bool):
	player_info().set_ready(value)
	Server.sync_local_players()
	
