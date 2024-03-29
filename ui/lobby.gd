class_name Lobby
extends Control

func setup():
	for player_panel in get_node("%GridContainer").get_children():
		player_panel.setup()


func _on_disconnect_button_pressed():
	Server.disconnect_from_server()
	UI.set_ui_state(GSGUI.UIState.MainMenu)
