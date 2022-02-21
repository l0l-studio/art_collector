extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var row_item = preload("res://Screens/RowItem.tscn")

onready var collected_container = get_node("ScrollContainer/HBoxContainer/CollectedContainer")
onready var targets_container = get_node("ScrollContainer/HBoxContainer/TargetsContainer")

onready var collected_total = get_node("Collected_total_value")
onready var targets_total = get_node("Target_total_value")

# Called when the node enters the scene tree for the first time.
func _ready():
#	var container
	$AudioStreamPlayer.playing = true
	var end_game_artworks = Global._get_artworks()
	var collected = end_game_artworks[0]
	var targets = end_game_artworks[1]
	
	$ArtInfo_Game_Over.set_art(targets[0])
	
	var collected_value = 0
	var target_value = 0
	
	for i in collected:
		collected_value += i.value
		var collected_item = row_item.instance()
		collected_item.initialize(i)
		collected_container.add_child(collected_item)
	
	for i in targets:
		target_value += i.value
	
	collected_total.text = String(collected_value)
	targets_total.text = String(target_value)
	
	if collected_value == target_value:
		$ResultText.text = "You Win!"
	else:
		$ResultText.text = "You Lose!"
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func _on_Button_pressed():
	Global._reset()
	get_tree().change_scene("res://World/testmap.tscn")
	pass # Replace with function body.
	
func _on_Button2_pressed():
	get_tree().quit()
	pass # Replace with function body.



