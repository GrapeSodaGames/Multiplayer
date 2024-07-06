class_name LobbyPlayer extends GSG_UIElement
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_number = 1

# Properties
var _is_first_run: bool = true
var _player: PlayerInfo

# References
@onready var _player_label: Label = get_node("%PlayerNumber")
@onready var _color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var _ready_button: Button = get_node("%ReadyButton")

# Game Loop


# Public Methods
func _ready():
	GameState.player_list_changed.connect(setup)
	GameState.player_list_changed.connect(_update)


# Private Methods
func reset():
	_player = null
	_player_label.text = ""
	_color_picker.color = Color.WHITE
	_color_picker.disabled = true
	_ready_button.button_pressed = false
	_ready_button.disabled = true
	_is_first_run = true
	

func setup():
	if not _player:
		#Log.info("Setting up LobbyPlayer #", _player_number)
		_player = GameState.get_players().by_number(_player_number)
		if _player:
			Log.info("Found " + str(_player.id()) + " as #", _player_number)
			if not _player.changed.is_connected(_update):
				_player.changed.connect(_update)


func _update():
	setup()
	if not _player or multiplayer.multiplayer_peer == null:
		Log.dbg("player is not connected: ", _player_number)
		reset()
		return

	Log.dbg("LobbyPlayer updating player number ", _player_number)

	if _player.is_local_player():
		if _is_first_run:
			_set_player_local_first()
		else:
			_set_player_local()
	else:
		_set_player_remote(_player)


func _set_player_local_first():
	setup()
	assert(_player.is_local_player())
	Log.info("First LobbyPlayer update for ", _player_number)
	_set_color_picker_local_first(_player.color())
	_is_first_run = false


func _set_player_local():
	assert(_player.is_local_player())

	_set_title_local(_player.number())
	_set_color_picker_local()
	_set_ready_button_local(_ready_button.button_pressed)


func _set_player_remote(player: PlayerInfo):
	assert(not player.is_local_player())

	_set_title_remote(player.number())
	_set_color_picker_remote(player)
	_set_ready_button_remote(player)


func _set_title_local(number: int):
	_player_label.text = str(number) + " - You"


func _set_title_remote(number: int):
	_player_label.text = str(number) + " - Connected"


func _set_color_picker_local():
	_color_picker.disabled = false


func _set_color_picker_local_first(color: Color):
	_color_picker.color = color


func _set_color_picker_remote(player: PlayerInfo):
	_color_picker.color = player.color()
	_color_picker.disabled = true


func _set_ready_button_local(value: bool):
	_ready_button.disabled = false
	if not value:
		_ready_button.text = "Ready"
	else:
		_ready_button.text = "Waiting for others..."


func _set_ready_button_remote(player: PlayerInfo):
	_ready_button.disabled = true
	if player.is_ready():
		_ready_button.button_pressed = player.is_ready()
		_ready_button.text = "Ready!"
	else:
		_ready_button.text = "Waiting for Confirmation"


# Events
func _on_color_picker_button_color_changed(color: Color):
	_player.set_color(color)


func _on_ready_button_toggled(toggled_on: bool):
	if _player:
		_player.set_ready(toggled_on)
