class_name Lobby
extends Control

@onready var start_game_button: Button = get_node("%StartGameButton")


func setup():
	if Server.is_host():
		_show_start_game_button()
	for player_panel in get_node("%GridContainer").get_children():
		player_panel.setup()


func _show_start_game_button():
	start_game_button.show()
	start_game_button.disabled = not Server.get_ready_status()


func _on_disconnect_button_pressed():
	Server.disconnect_from_server()
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_start_game_button_pressed():
	UI.set_ui_state(GSGUI.UIState.WORLD)
