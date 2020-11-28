extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var row_item = preload("res://Screens/RowItem.tscn")

onready var collected_container = get_node("ScrollContainer/HBoxContainer/CollectedContainer")
onready var targets_container = get_node("ScrollContainer/HBoxContainer/TargetsContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
#	var container
	
	var end_game_artworks = Global._get_artworks()
	var collected = end_game_artworks[0]
	var targets = end_game_artworks[1]
	
	var collected_value = 0
	var target_value = 0
	
	for i in collected:
		collected_value += i.value
		var collected_item = row_item.instance()
		collected_item.initialize(i)
		collected_container.add_child(collected_item)
	
	for i in targets:
		target_value += i.value
	
	
	
	print(collected_value," ", target_value)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
