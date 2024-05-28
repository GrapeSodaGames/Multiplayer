class_name Lobby extends UIScreen
## TODO: Document

# Signals

# Enums

# Exports

# References
@onready var start_game_button: Button = get_node("%StartGameButton")

# Properties

# Game Loop

# Public Methods
func setup():
	super.setup()

	if GameState.is_host():
		_show_start_game_button()


func enable(value: bool):
	super.enable(value)


# Private Methods
func _show_start_game_button():
	start_game_button.show()
	#start_game_button.disabled = not GameState.get_players().get_ready_status()


# Events
func _on_disconnect_button_pressed():
	ui.request_disconnect_from_server()
	ui.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_start_game_button_pressed():
	ui.set_ui_state(GSGUI.UIState.WORLD)
