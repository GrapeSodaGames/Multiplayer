class_name GSGGame extends Node

var _player_info = PlayerInfo.new()
@onready var local_config: LocalConfig = get_node("LocalConfig")


func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	Log.dbg("Game Ready")


func player_info():
	return _player_info


func send_player_to_server():
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), player_info().serialize())


func _on_server_connect_success():
	Log.info("Game received server connect success")
	local_config.set_config_server_ip(Server.connection_manager.get_server_ip())
