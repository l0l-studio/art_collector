extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func initialize(data):
	var art_image = $ArtWork.get_node("Sprite")
	art_image.texture = data.texture
	art_image.visible = true
	
	
