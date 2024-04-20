class_name LobbyPlayer
extends PanelContainer

@export var _player_number: int
var _player: PlayerInfo

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")


func _ready():
	color_picker.disabled = true

func _process(_delta):
	update()	


func update():
	for player: PlayerInfo in Server.players.values():
		if player.number() == _player_number:
			_player = player
		
	
	_set_title(_player)
	_set_color_picker(_player)
	_set_ready_button(_player)
	
	
func _set_title(player: PlayerInfo):
	player_label.text = "Player " + str(_player_number)
	if not player:
		player_label.text = ""
		return
	if _player_number == player.number():
		if player.id() == multiplayer.get_unique_id():
			player_label.text += " - You"
		else:
			player_label.text += " - Connected"


func _set_color_picker(player: PlayerInfo):
	if not player:
		color_picker.color = Color.WHITE
		return
	if _player_number == player.number():
		color_picker.color = player.color()
	if player.id() == multiplayer.get_unique_id():
		color_picker.disabled = false
	color_picker.disabled = player.is_ready()
		
func _set_ready_button(player):
	if not player:
		ready_button.text = "Not Connected"
		return
	
	if player.is_ready():
		ready_button.text = "Waiting for Others"
	else:
		ready_button.text = "Ready"



func _on_color_picker_button_color_changed(color: Color):
	Server.set_player_color(color)


func _on_ready_button_toggled(toggled_on):
	if not _player:
		return
	if _player.id() == multiplayer.get_unique_id():
		UI.request_set_player_ready.emit(toggled_on)
	
