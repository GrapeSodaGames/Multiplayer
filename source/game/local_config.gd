class_name LocalConfig extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References
@export var config_path = "user://config.ini"

# Properties
var _config_file: ConfigFile

# Game Loop
func _init():
	_config_file = ConfigFile.new()
	var err = _config_file.load(config_path)
	if err != OK:
		_create_default_config_file()
	Log.dbg("Config Loaded Successfully")
	Log.dbg("config file: ", _config_file.encode_to_text())


# Public Methods
func get_config_server_ip() -> Variant:
	return _config_file.get_value("general", "last_connected_ip")


func set_config_server_ip(new_ip):
	_config_file.set_value("general", "last_connected_ip", new_ip)
	_save_config()


# Private Methods
func _create_default_config_file():
	Log.info("Creating default config file")
	set_config_server_ip("127.0.0.1")


func _save_config():
	_config_file.save(config_path)

# Events
