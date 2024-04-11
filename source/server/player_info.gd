class_name PlayerInfo

var _player_number: int
var _color: Color
var _is_ready: bool


func number():
	return _player_number

func set_player_number(value: int):
	_player_number = value

func color():
	return _color


func set_color(color: Color):
	_color = color

func ready() -> bool:
	return _is_ready



func set_ready(value: bool):
	_is_ready = value

func serialize() -> String:
	return "{\"player_number\": "+ str(_player_number) +", \"color\": \""+_color.to_html()+"\", \"is_ready\": "+ str(_is_ready) +"}"

static func deserialize(input: String) -> PlayerInfo:
	var json = JSON.new()
	var err = json.parse(input)
	if err != OK:
		return
	
	var result: PlayerInfo = PlayerInfo.new()
	result.set_player_number(json.data["player_number"])
	result.set_color(json.data["color"])
	result.set_ready(json.data["is_ready"])

	return result
