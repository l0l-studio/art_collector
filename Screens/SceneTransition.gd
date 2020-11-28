extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#https://www.gdquest.com/tutorial/godot/2d/scene-transition-rect/
# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays the animation backward to fade in
	_anim_player.play_backwards("Fade")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func transition_to(_next_scene := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	print("animation should play")
	print(_anim_player)
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	if typeof(_next_scene) == TYPE_STRING:
		get_tree().change_scene(_next_scene)
	else:
		get_tree().change_scene_to(_next_scene)
