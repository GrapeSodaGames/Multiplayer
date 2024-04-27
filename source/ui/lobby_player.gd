class_name LobbyPlayer
extends PanelContainer

@export var _player_number = 1

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")
@onready var game: GSGGame = get_node("/root/Game")


func _ready():
	color_picker.disabled = true


func _process(_delta):
	update()


func update():
	Log.info("LobbyPlayer updating player number ", _player_number)
	for player: PlayerInfo in Server.get_players().all():
		if _player_number == player.number():
			Log.info("LobbyPlayer comparing to player: ", player.serialize())
			_set_title(player)
			_set_color_picker(player)
			_set_ready_button(player)


func _set_title(player: PlayerInfo):
	player_label.text = "Player " + str(_player_number)
	if player.is_local_player():
		player_label.text += " - You"
	else:
		player_label.text += " - Connected"


func _set_color_picker(player: PlayerInfo):
	if not player.is_local_player():
		color_picker.color = player.color()
		color_picker.disabled = true
	else:
		color_picker.disabled = player.is_ready()


func _set_ready_button(player: PlayerInfo):
	if not player.is_local_player():
		ready_button.disabled = true
		if player.is_ready():
			ready_button.button_pressed = player.is_ready()
			ready_button.text = "Ready!"
		else:
			ready_button.text = "Waiting for Confirmation"
	else:
		ready_button.disabled = false
		if not player.is_ready():
			ready_button.text = "Ready"
		else:
			ready_button.text = "Waiting for others..."


func _on_color_picker_button_color_changed(color: Color):
	game.player_info().set_color(color)


func _on_ready_button_toggled(toggled_on):
	game.player_info().set_ready(toggled_on)
