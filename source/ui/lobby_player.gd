class_name LobbyPlayer extends PanelContainer
## TODO: Document

# Signals

# Enums

# Exports
@export var _player_number = 1

# References
@onready var _player_label: Label = get_node("%PlayerLabel")
@onready var _color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var _ready_button: Button = get_node("%ReadyButton")
@onready var _game: GSGGame = get_node("/root/Game")

# Properties

# Game Loop
func _ready():
	_color_picker.disabled = true


func _process(_delta):
	_update()


# Public Methods
func _update():
	Log.dbg("LobbyPlayer updating player number ", _player_number)
	for player: PlayerInfo in Server.get_players().all():
		if _player_number == player.number():
			Log.dbg("LobbyPlayer comparing to player: ", player.serialize())
			_set_title(player)
			_set_color_picker(player)
			_set_ready_button(player)


# Private Methods
func _set_title(player: PlayerInfo):
	_player_label.text = "Player " + str(_player_number)
	if player.is_local_player():
		_player_label.text += " - You"
	else:
		_player_label.text += " - Connected"


func _set_color_picker(player: PlayerInfo):
	if not player.is_local_player():
		_color_picker.color = player.color()
		_color_picker.disabled = true
	else:
		_color_picker.disabled = player.is_ready()


func _set_ready_button(player: PlayerInfo):
	if not player.is_local_player():
		_ready_button.disabled = true
		if player.is_ready():
			_ready_button.button_pressed = player.is_ready()
			_ready_button.text = "Ready!"
		else:
			_ready_button.text = "Waiting for Confirmation"
	else:
		_ready_button.disabled = false
		if not player.is_ready():
			_ready_button.text = "Ready"
		else:
			_ready_button.text = "Waiting for others..."


# Events
func _on_color_picker_button_color_changed(color: Color):
	_game.player_info().set_color(color)


func _on_ready_button_toggled(toggled_on):
	_game.player_info().set_ready(toggled_on)
