class_name LobbyPlayer extends PanelContainer
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_number = 1

# Properties
var _is_first_run: bool = true

# References
@onready var _player_label: Label = get_node("%PlayerNumber")
@onready var _color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var _ready_button: Button = get_node("%ReadyButton")
@onready var _game: GSGGame = get_node("/root/Game")

# Game Loop
func _process(_delta):
	_update()


# Public Methods

# Private Methods
func _update():
	if not Server.is_peer_connected():
		return
	Log.dbg("LobbyPlayer updating player number ", _player_number)
	
	var player: PlayerInfo = Server.get_players().by_number(_player_number)
	if not player is PlayerInfo:
		return
	if player.is_local_player():
		player = _game.player_info()
		if _is_first_run:
			Log.info("LobbyPlayer beginning first run")
			_set_player_local_first(player)
			Log.info("LobbyPlayer first run complete")
			_is_first_run = false
		else:
			_set_player_local(player)
	else:
		_set_player_remote(player)


func _set_player_local_first(player: PlayerInfo):
	#assert(player.is_local_player())
	
	_set_color_picker_local_first(player.color())

func _set_player_local(player: PlayerInfo):
	#assert(player.is_local_player())
	
	_set_title_local(player.number())
	_set_color_picker_local()
	_set_ready_button_local(player.is_ready())


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
	_game.player_info().set_color(color)


func _on_ready_button_toggled(toggled_on):
	_game.player_info().set_ready(toggled_on)
