class_name DebugPlayerInfo extends VBoxContainer
## TODO: Document

# Signals

# Enums

# Exports

# References
@onready var panel = get_node("PanelContainer")
@onready var player_1_status = get_node("%Status1Value")
@onready var player_1_id = get_node("%ID1Value")
@onready var player_1_color = get_node("%Color1Value")
@onready var player_1_ready = get_node("%Ready1Value")

@onready var player_2_status = get_node("%Status2Value")
@onready var player_2_id = get_node("%ID2Value")
@onready var player_2_color = get_node("%Color2Value")
@onready var player_2_ready = get_node("%Ready2Value")

@onready var player_3_status = get_node("%Status3Value")
@onready var player_3_ready = get_node("%Ready3Value")

@onready var player_4_status = get_node("%Status4Value")
@onready var player_4_ready = get_node("%Ready4Value")

# Properties

# Game Loop
func _process(_delta):
	if GameState.is_peer_connected():
		var players = GameState.get_players()
		for player: PlayerInfo in players.all():
			if player.number() == 1:
				if player.is_local_player():
					player_1_status.text = "THIS IS ME"
				else:
					player_1_status.text = "CONNECTED"
				player_1_id.text = str(player.id())
				player_1_color.text = player.color().to_html()
				player_1_ready.text = str(player.is_ready())
			elif player.number() == 2:
				if player.is_local_player():
					player_2_status.text = "THIS IS ME"
				else:
					player_2_status.text = "CONNECTED"
				player_2_id.text = str(player.id())
				player_2_color.text = player.color().to_html()
				player_2_ready.text = str(player.is_ready())
			elif player.number() == 3:
				if player.is_local_player():
					player_3_status.text = "THIS IS ME"
				else:
					player_3_status.text = "CONNECTED"
				player_3_ready.text = str(player.is_ready())
			elif player.number() == 4:
				if player.is_local_player():
					player_4_status.text = "THIS IS ME"
				else:
					player_4_status.text = "CONNECTED"
				player_4_ready.text = str(player.is_ready())

	else:
		player_1_status.text = ""
		player_1_ready.text = ""

		player_2_status.text = ""
		player_2_ready.text = ""

		player_3_status.text = ""
		player_3_ready.text = ""

		player_4_status.text = ""
		player_4_ready.text = ""


# Public Methods

# Private Methods

# Events
func _on_button_toggled(toggled_on):
	panel.visible = toggled_on
