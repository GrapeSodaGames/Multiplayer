class_name LobbyPlayer
extends PanelContainer

@export var _player_number = 1

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")


func _ready():
	color_picker.disabled = true


func _process(_delta):
	update()


func update():
	for id in Server.get_players():
		var player = Server.get_player(id)
		if _player_number == player["player_number"]:
			_set_title(id)
			_set_color_picker(id, player)
			_set_ready_button(id, player)


func _set_title(id):
	player_label.text = "Player " + str(_player_number)
	if id == multiplayer.get_unique_id():
		player_label.text += " - You"
	else:
		player_label.text += " - Connected"


func _set_color_picker(id, player):
	color_picker.color = Color.from_string(player["color"], Color.WHITE)
	if id == multiplayer.get_unique_id():
		color_picker.disabled = false
	color_picker.disabled = player.is_ready


func _set_ready_button(id, player):
	if player.is_ready:
		ready_button.text = "Ready!"
	else:
		ready_button.text = "Waiting for Confirmation"
	if id == multiplayer.get_unique_id() and _player_number == player["player_number"]:
		ready_button.disabled = false
		ready_button.button_pressed = player.is_ready
		if not player.is_ready:
			ready_button.text = "Ready"
		else:
			ready_button.text = "Waiting for others..."


func _on_color_picker_button_color_changed(color: Color):
	Server.set_player_color(color)


func _on_ready_button_toggled(toggled_on):
	Server.set_player_ready(toggled_on)
