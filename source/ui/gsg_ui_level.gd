class_name GSG_UILevel extends Control
## This class represents the top level items in the UI.  They each render 
## on top of everything else.
##
## A UILevel contains UIScreens.

# Signals

# Enums
enum Menu { MAIN_MENU, LOBBY, WORLD, CREDITS }
# Exports
@export var persistent: bool = false

# Properties
#var _ui_state: Menu
#var _new_ui_state: Menu
var _screens = {}
#
## References
#@onready var _main_menu: MainMenu = get_node("Main Menu")
#@onready var _lobby: Lobby = get_node("Lobby")
#@onready var _world: WorldUI = get_node("World")
#@onready var _credits: Credits = get_node("Credits")
#
## Game Loop
func _ready():
	for screen: UIScreen in get_children():
		Log.dbg("Found UI Screen: ", screen.name)
		screen.change_screen.connect(_on_screen_change)
		_screens[screen.name] = screen
		
	#_screens[Menu.WORLD] = _world
	#_screens[Menu.MAIN_MENU] = _main_menu
	#_screens[Menu.LOBBY] = _lobby
	#_screens[Menu.CREDITS] = _credits
#
	#_ui_state = Menu.WORLD
	#_new_ui_state = Menu.MAIN_MENU
#
## Public Methods
func enable(value: bool):
	visible = not value
	if value:
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		process_mode = Node.PROCESS_MODE_INHERIT
	
func show_screen(screen: String):
	_close_all()
	_screens[screen].enable(true)

## Private Methods
func _close_all():
	for screen: UIScreen in _screens.values():
		screen.enable(false)
## Events
func _on_screen_change(screen: String):
	show_screen(screen)
