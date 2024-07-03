class_name GSGUI extends Node
## TODO: Document

# Signals
signal request_create_new_server_signal(port)
signal request_connect_to_server_signal(ip, port)
signal request_disconnect_from_server_signal

# Enums

# Exports

# Properties
var _levels = {}

# References

# Game Loop


func _ready():
	Log.dbg("UI Readying...")

	GameState.connection_succeeded.connect(_on_connection_success)
	GameState.game_ended.connect(_on_game_ended)
	
	for ui_level: GSG_UILevel in get_children():
		Log.dbg("Found UI Level: ", ui_level.name)
		_levels[ui_level.name] = ui_level

	Log.dbg("UI Ready")


# Public Methods


# Private Methods
func _enable_ui_level(level: GSG_UILevel):
	level.enable(true)


func _close_all():
	for level: GSG_UILevel in _levels.values():
		if level.persistent == false:
			level.enable(false)


# Events
func _on_connection_success():
	_levels["MenuLevel"].show_screen("Lobby")


func _on_game_ended():
	pass
