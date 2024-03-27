class_name LobbyPlayer
extends PanelContainer

@export var player_number = 1

@onready var global: Main = get_tree().root.get_node("Main")

@onready var player_label: Label = get_node("%PlayerLabel")
@onready var color_picker: ColorPickerButton = get_node("%ColorPickerButton")
@onready var ready_button: Button = get_node("%ReadyButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	color_picker.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup():
	player_label.text = "Player " + str(player_number)
	for id in global.server.players:
		var player = global.server.players[id] 
		if player_number == player["player_number"]:
			color_picker.color = Color.from_string(player["color"], Color.WHITE)

			if id == multiplayer.get_unique_id(): 
				player_label.text += " - You"
				color_picker.disabled = false
			else:
				player_label.text += " - Connected"

func set_player_color(color: Color):
	var id = multiplayer.get_unique_id()
	global.server.players[id]["color"] = color.to_html()
	global.server.send_player_info.rpc_id(1,id, global.server.players[id])





func _on_color_picker_button_color_changed(color: Color):
	set_player_color(color)
