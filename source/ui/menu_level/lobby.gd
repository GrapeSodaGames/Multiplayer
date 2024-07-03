class_name Lobby extends UIScreen
## TODO: Document

# Signals

# Enums

# Exports

# References
@onready var start_game_button: Button = get_node("%StartGameButton")

# Properties


# Game Loop
func _process(_delta):
	start_game_button.disabled = not GameState.get_players().get_ready_status()


# Public Methods
func setup():
	super.setup()

	if GameState.is_host():
		_show_start_game_button()


func enable(value: bool):
	super.enable(value)
	setup()


# Private Methods
func _show_start_game_button():
	start_game_button.show()


# Events
func _on_disconnect_button_pressed():
	GameState.disconnect_from_server()
	change_screen.emit("Main Menu")


func _on_start_game_button_pressed():
	GameState.begin_game()
