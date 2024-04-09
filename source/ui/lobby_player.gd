class_name LobbyPlayer
extends PanelContainer

@export var player_number = 1

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")


func _ready():
	color_picker.disabled = true


#TODO: Code Smell - Long Method
func setup():
	player_label.text = "Player " + str(player_number)
	for id in Server.get_players():
		var player = Server.get_player(id)
		if player_number == player["player_number"]:
			color_picker.color = Color.from_string(player["color"], Color.WHITE)
			if player.is_ready:
				ready_button.text = "Ready!"
			else:
				ready_button.text = "Waiting for Confirmation"

			if id == multiplayer.get_unique_id():
				player_label.text += " - You"
				color_picker.disabled = false
				ready_button.disabled = false
				ready_button.button_pressed = player.is_ready
				if not player.is_ready:
					ready_button.text = "Ready"
				else:
					ready_button.text = "Waiting for others..."

			else:
				player_label.text += " - Connected"


func _on_color_picker_button_color_changed(color: Color):
	Server.set_player_color(color)


func _on_ready_button_toggled(toggled_on):
	Server.set_player_ready(toggled_on)
