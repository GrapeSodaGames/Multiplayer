class_name Lobby
extends Control

@onready var server: GSGServer = get_tree().root.get_node("Main/Server") 
@onready var ui: GSGUI = get_tree().root.get_node("Main/UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup():
	for player_panel in get_node("%GridContainer").get_children():
		player_panel.setup()


func _on_disconnect_button_pressed():
	server.disconnect_from_server()
	ui.set_ui_state(GSGUI.UIState.MainMenu)
