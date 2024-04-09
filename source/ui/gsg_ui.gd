class_name GSGUI
extends Node

enum UIState { MAIN_MENU, LOBBY, WORLD }

var ui_state: UIState
var new_ui_state: UIState

@onready var main_menu: MainMenu = get_node("Main Menu")
@onready var debug_log = get_node("Debug Log")
@onready var lobby = get_node("Lobby")
@onready var world = get_node("World")


func _ready():
	ui_state = UIState.WORLD
	new_ui_state = UIState.MAIN_MENU

	Server.connection_success.connect(_on_connection_success)

	main_menu.request_connect_to_server.connect(_on_connect_request)
	main_menu.request_create_new_server.connect(_on_create_host_request)
	Log.info("UI Ready")


func _process(_delta):
	check_state()


func check_state():
	if multiplayer.multiplayer_peer == null:
		new_ui_state = UIState.MAIN_MENU
	if new_ui_state != ui_state:
		close_all()
		ui_state = new_ui_state
	match ui_state:
		UIState.MAIN_MENU:
			main_menu.set_process(true)
			main_menu.show()
		UIState.LOBBY:
			main_menu.set_process(true)
			lobby.setup()
			lobby.show()
		UIState.WORLD:
			world.set_process(true)
			world.setup()
			world.show()


func close_all():
	main_menu.hide()
	main_menu.set_process(false)
	lobby.hide()
	lobby.set_process(false)
	world.hide()
	world.set_process(false)


func set_ui_state(state: UIState):
	new_ui_state = state


func _on_connection_success():
	set_ui_state(UIState.LOBBY)


func _on_connect_request(ip, port):
	Server.connect_to_server(ip, port)


func _on_create_host_request():
	Server.create_server()
