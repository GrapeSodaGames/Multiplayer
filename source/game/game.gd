class_name GSGGame extends Node

@export var config_path = "user://config.ini"

var _config: ConfigFile
var _player_info: PlayerInfo

func _init():
	#Log.current_log_level = Log.LogLevel.DEBUG
	Log.dbg("Game Initializing...")
	_player_info = PlayerInfo.new()
	_config = ConfigFile.new()
	var err = _config.load(config_path)
	if err != OK:
		_create_default_config_file()
	Log.info("Config Loaded Successfully")
	Log.dbg("config file: ", _config.encode_to_text())
	Log.dbg("Game Initialized")


func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	Server.player_connected.connect(_on_server_player_updated)
	Log.dbg("Game Ready")

func poll():
	if Server.is_peer_connected():
		Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), _player_info.serialize())

func _create_default_config_file():
	Log.info("Creating default config file")
	set_config_server_ip("127.0.0.1")


func _on_server_connect_success():
	Log.info("Game received server connect success")
	set_config_server_ip(Server.get_server_ip())
	save_config()


func save_config():
	_config.save(config_path)


func get_config_server_ip() -> Variant:
	return _config.get_value("general", "last_connected_ip")


func set_config_server_ip(new_ip):
	_config.set_value("general", "last_connected_ip", new_ip)
	save_config()


func _on_timer_timeout():
	poll() 

func _on_server_player_updated(id, info):
	if multiplayer.get_unique_id() == id:
		_player_info = info
