extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var time_node = get_node("time")
onready var score_node = get_node("score")
onready var capacity_node = get_node("capacity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_node.text = String(Global._get_time())
	pass

func _on_Collected(data):
	var current_state = Global._get_state()
	time_node.text = String(current_state.time)
	score_node.text = String(current_state.score)
	capacity_node.text = String(current_state.capacity)

func _initialize():
	capacity_node.text = String(Global._get_state().capacity)
