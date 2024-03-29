class_name GSGUI
extends Node

signal request_connect_to_server(ip, port)
signal request_create_new_server
signal request_disconnect

enum UIState {
	MainMenu,
	Lobby,
	Game
}

var ui_state: UIState
var new_ui_state: UIState

@onready var main: Main = get_tree().root.get_node("Main")
@onready var server: GSGServer = get_tree().root.get_node("Main/Server")
@onready var main_menu: MainMenu = get_node("Main Menu")
@onready var debug_log = get_node("Debug Log")
@onready var lobby = get_node("Lobby")

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_state = UIState.Game
	new_ui_state = UIState.MainMenu

	server.connection_sucess.connect(_on_connection_success)

	main_menu.request_connect_to_server.connect(_on_connect_request)
	main_menu.request_create_new_server.connect(_on_create_host_request)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_state()

func check_state():
	if multiplayer.multiplayer_peer == null:
		new_ui_state = UIState.MainMenu
	if new_ui_state != ui_state:
		close_all()
		ui_state = new_ui_state
	match ui_state:
		UIState.MainMenu:
			if not main_menu.visible:
				main_menu.visible = true
		UIState.Lobby:
			lobby.setup()
			if not lobby.visible:
				lobby.visible = true
				
		
func close_all():
	main_menu.visible = false
	lobby.visible = false

func set_ui_state(state: UIState):
	new_ui_state = state

func _on_connection_success():
	set_ui_state(UIState.Lobby)

func _on_connect_request(ip, port):
	request_connect_to_server.emit(ip, port)

func _on_create_host_request():
	request_create_new_server.emit()


