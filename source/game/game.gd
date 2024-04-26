class_name GSGGame extends Node

@onready var local_config: LocalConfig = get_node("LocalConfig")

var _player_info = LocalPlayerInfo.new()

func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	Log.dbg("Game Ready")

func _process(delta):
	if Server.is_peer_connected():
		Server.send_player_info.rpc(multiplayer.get_unique_id(), _player_info.serialize())
		#Log.info("", _player_info.serialize())


func player_info() -> PlayerInfo:
	return _player_info


func set_player_info(new_player_info: PlayerInfo):
	_player_info.set_id(new_player_info.id())
	_player_info.set_player_number(new_player_info.number())
	_player_info.set_color(new_player_info.color())
	_player_info.set_ready(new_player_info.is_ready())

func _on_server_connect_success():
	Log.info("Game received server connect success")
	local_config.set_config_server_ip(Server.connection_manager.get_server_ip())
	Server.send_player_info(multiplayer.get_unique_id(), _player_info.serialize())
