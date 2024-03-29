class_name LobbyPlayer
extends PanelContainer

@export var player_number = 1

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")


func _ready():
	color_picker.disabled = true


func setup():
	player_label.text = "Player " + str(player_number)
	for id in Server.players:
		var player = Server.players[id] 
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

func set_player_color(color: Color):
	var id = multiplayer.get_unique_id()
	Server.players[id]["color"] = color.to_html()
	Server.send_player_info.rpc_id(1,id, Server.players[id])

func set_player_ready_status(is_ready: bool):
	var id = multiplayer.get_unique_id()
	Server.players[id].is_ready = is_ready
	Server.send_player_info.rpc_id(1, id, Server.players[id])



func _on_color_picker_button_color_changed(color: Color):
	set_player_color(color)


func _on_ready_button_toggled(toggled_on):
	set_player_ready_status(toggled_on)
