class_name GSGGame extends Node

const CONFIG_PATH = "user://config.ini"

var config: ConfigFile


func _init():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err != OK:
		create_default_config_file()
	Log.info("Config Loaded: ", config.encode_to_text())
	Log.info("Game Initialized")


func _ready():
	Server.connection_success.connect(_on_server_connect_success)
	Log.info("Game Ready")


func create_default_config_file():
	Log.info("Creating default config file")
	set_config_server_ip("127.0.0.1")


func _on_server_connect_success():
	Log.info("Game received server connect success")
	var ip = Server.get_server_ip()
	set_config_server_ip(ip)
	Log.info("Server ip is ", ip)

	save_config()


func save_config():
	config.save(CONFIG_PATH)


func get_config_server_ip() -> Variant:
	return config.get_value("general", "last_connected_ip")


func set_config_server_ip(new_ip):
	config.set_value("general", "last_connected_ip", new_ip)
	save_config()
