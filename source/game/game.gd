class_name GSGGame extends Node

@onready var local_config: LocalConfig = get_node("LocalConfig")


func _ready():
	Log.dbg("Game Readying...")
	Server.connection_success.connect(_on_server_connect_success)
	Log.dbg("Game Ready")


func _on_server_connect_success():
	Log.info("Game received server connect success")
	local_config.set_config_server_ip(Server.connection_manager.get_server_ip())
