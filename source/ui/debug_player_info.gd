class_name DebugPlayerInfo extends VBoxContainer

@onready var panel = get_node("PanelContainer")

@onready var player_1_id = get_node("%ID1Value")
@onready var player_1_status = get_node("%Status1Value")
@onready var player_1_ready = get_node("%Ready1Value")

@onready var player_2_id = get_node("%ID2Value")
@onready var player_2_status = get_node("%Status2Value")
@onready var player_2_ready = get_node("%Ready2Value")

@onready var player_3_status = get_node("%Status3Value")
@onready var player_3_ready = get_node("%Ready3Value")

@onready var player_4_status = get_node("%Status4Value")
@onready var player_4_ready = get_node("%Ready4Value")

# TODO: Code Smell - Long Method 
func _process(_delta):
	if Server.is_peer_connected():
		var players = Server.get_players()
		for id in players.all():
			if players.get_by_id(id).number() == 1:
				if multiplayer.get_unique_id() == id:
					player_1_status.text = "THIS IS ME"
				else:
					player_1_status.text = "CONNECTED"
				player_1_id.text = str(id)
				player_1_ready.text = str(players.get_by_id(id).is_ready())
			elif players.get_by_id(id).number() == 2:
				if multiplayer.get_unique_id() == id:
					player_2_status.text = "THIS IS ME"
				else:
					player_2_status.text = "CONNECTED"
				player_2_id.text = str(id)
				player_2_ready.text = str(players.get_by_id(id).is_ready())
			elif players.get_by_id(id).number() == 3:
				if multiplayer.get_unique_id() == id:
					player_3_status.text = "THIS IS ME"
				else:
					player_3_status.text = "CONNECTED"
				player_3_ready.text = str(players.get_by_id(id).is_ready())
			elif players.get_by_id(id).number() == 4:
				if multiplayer.get_unique_id() == id:
					player_4_status.text = "THIS IS ME"
				else:
					player_4_status.text = "CONNECTED"
				player_4_ready.text = str(players.get_by_id(id).is_ready())

	else:
		player_1_status.text = ""
		player_1_ready.text = ""

		player_2_status.text = ""
		player_2_ready.text = ""

		player_3_status.text = ""
		player_3_ready.text = ""

		player_4_status.text = ""
		player_4_ready.text = ""


func _on_button_toggled(toggled_on):
	panel.visible = toggled_on
