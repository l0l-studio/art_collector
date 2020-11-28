extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _time
var _score = 0
var _capacity = 0 setget set_capacity
var _collected = []

var _targets = [] setget set_targets

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_capacity(value):
	_capacity = value
	
func set_targets(value):
	_targets = value

func _add_score(points):
	_score += points

func _add_to_collected(art):
	_collected.append(art)

func _decrement_capacity():
	self._capacity -= 1
	return _capacity
	
func _update_time(value):
	_time = value
	
func _get_state():
	return {
		"time": _time,
		"score": _score,
		"capacity": _capacity
	}

func _get_artworks():
	return [_collected, _targets]
	

func _get_time():
	return _time
	


