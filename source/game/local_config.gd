class_name LocalConfig extends Node

@export var config_path = "user://config.ini"

var _config_file: ConfigFile

func _init():
	_config_file = ConfigFile.new()
	var err = _config_file.load(config_path)
	if err != OK:
		_create_default_config_file()
	Log.info("Config Loaded Successfully")
	Log.dbg("config file: ", _config_file.encode_to_text())
	
func _create_default_config_file():
	Log.info("Creating default config file")
	set_config_server_ip("127.0.0.1")
	


func _save_config():
	_config_file.save(config_path)


func get_config_server_ip() -> Variant:
	return _config_file.get_value("general", "last_connected_ip")


func set_config_server_ip(new_ip):
	_config_file.set_value("general", "last_connected_ip", new_ip)
	_save_config()
