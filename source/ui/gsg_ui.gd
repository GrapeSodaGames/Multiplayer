class_name GSGUI extends Node
## TODO: Document

# Signals
signal request_create_new_server_signal(port)
signal request_connect_to_server_signal(ip, port)
signal request_disconnect_from_server_signal


# Enums
enum UIState { MAIN_MENU, LOBBY, WORLD, CREDITS }

# Exports

# Properties
var _ui_state: UIState
var _new_ui_state: UIState
var _screens = {}

# References
@onready var _main_menu: MainMenu = get_node("Main Menu")
@onready var _lobby: Lobby = get_node("Lobby")
@onready var _world: WorldUI = get_node("World")
@onready var _credits: Credits = get_node("Credits")

# Game Loop


func _ready():
	Log.dbg("UI Readying...")

	_screens[UIState.WORLD] = _world
	_screens[UIState.MAIN_MENU] = _main_menu
	_screens[UIState.LOBBY] = _lobby
	_screens[UIState.CREDITS] = _credits

	_ui_state = UIState.WORLD
	_new_ui_state = UIState.MAIN_MENU

	GameState.connection_succeeded.connect(_on_connection_success)
	GameState.game_ended.connect(_on_game_ended)

	Log.dbg("UI Ready")


# Public Methods
func set_ui_state(state: UIState):
	_new_ui_state = state
	_check_state()


# Private Methods
func _check_state():
	if _new_ui_state != _ui_state:
		Log.dbg("new UI state detected: ", str(_ui_state) + "=>" + str(_new_ui_state))

		if _new_ui_state == UIState.LOBBY and not GameState.is_peer_connected():
			_new_ui_state = UIState.MAIN_MENU

		_close_all()
		_ui_state = _new_ui_state
		_screens[_ui_state].enable(true)


func _close_all():
	for screen: UIScreen in _screens.values():
		screen.enable(false)


# Events
func _on_connection_success():
	set_ui_state(UIState.LOBBY)

func _on_game_ended():
	set_ui_state(UIState.MAIN_MENU)
