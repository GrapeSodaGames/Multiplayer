class_name Lobby extends UIScreen

@onready var start_game_button: Button = get_node("%StartGameButton")


func setup():
	super.setup()

	if Server.is_host():
		_show_start_game_button()


func enable(value: bool):
	super.enable(value)


func _show_start_game_button():
	start_game_button.show()
	start_game_button.disabled = not Server.get_players().get_ready_status()


func _on_disconnect_button_pressed():
	UI.request_disconnect_from_server()
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_start_game_button_pressed():
	UI.set_ui_state(GSGUI.UIState.WORLD)
