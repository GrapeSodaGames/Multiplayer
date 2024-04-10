class_name GSGUI extends Node

enum UIState { MAIN_MENU, LOBBY, WORLD }

var _ui_state: UIState
var _new_ui_state: UIState
var _screens = {}

@onready var main_menu: MainMenu = get_node("Main Menu")
@onready var debug_log: DebugLog = get_node("Debug Log")
@onready var lobby: Lobby = get_node("Lobby")
@onready var world: WorldUI = get_node("World")


func _ready():
	Log.dbg("UI Readying...")

	_screens[UIState.WORLD] = world
	_screens[UIState.MAIN_MENU] = main_menu
	_screens[UIState.LOBBY] = lobby

	_ui_state = UIState.WORLD
	_new_ui_state = UIState.MAIN_MENU

	Server.connection_success.connect(_on_connection_success)
	Server.connection_failed.connect(_on_connection_failed)

	main_menu.request_connect_to_server.connect(_on_connect_request)
	main_menu.request_create_new_server.connect(_on_create_host_request)
	Log.dbg("UI Ready")


func _process(_delta):
	_check_state()
	_screens[_ui_state].setup()
	_screens[_ui_state].enable(true)


func _check_state():
	if not Server.is_peer_connected():
		_new_ui_state = UIState.MAIN_MENU
	if _new_ui_state != _ui_state:
		close_all()
		_ui_state = _new_ui_state


func close_all():
	for screen: UIScreen in _screens.values():
		screen.enable(false)


func set_ui_state(state: UIState):
	_new_ui_state = state


func _on_connection_success():
	set_ui_state(UIState.LOBBY)


func _on_connection_failed():
	Log.info("UI received connection failed from server")
	main_menu.clear_ip_text()


func _on_connect_request(ip, port):
	Server.connect_to_server(ip, port)


func _on_create_host_request():
	Server.create_server()
