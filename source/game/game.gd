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
	Log.dbg("Game Ready")

# Public Methods
func player_info():
	return _player_info
	
func local_config():
	return _local_config

# Private Methods

# Events
func _on_server_connect_success():
	Log.info("Game received server connect success")
	_local_config.set_config_server_ip(Server.connection_manager().get_server_ip())
