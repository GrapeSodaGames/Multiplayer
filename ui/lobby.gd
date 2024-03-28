extends Control

@onready var server: GSGServer = get_tree().root.get_node("Main/Server") 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup():
	for player_panel in get_node("GridContainer").get_children():
		player_panel.setup()
