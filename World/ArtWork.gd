extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal viewArt(data)
signal closeArt

const TIME_MIN_MAX = [3,10]

# data stores name, time_to_collect, points/value etc
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(name, texture):
	var sprite = get_node("Sprite")
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	sprite.texture = texture
	
	data.name = name
	data.texture = texture
	#bell curved more likely to spawn lower/average values
	data.time_to_collect = TIME_MIN_MAX[0] + int(round(abs(rng.randfn(0.0, TIME_MIN_MAX[1]))))
	data.value = data.time_to_collect * data.time_to_collect

func get_data():
	return data

func _on_Sprite_texture_changed():
	# Assuming the area has a child CollisionShape2D with a RectangleShape resource
	var area = self.get_node("Area2D")
	var sprite = self.get_node("Sprite")
	var area_size = area.get_node("CollisionShape2D").shape.extents * 2.0

# The size of a sprite is determined from its texture
	var texture_size = sprite.texture.get_size()

# Calculate which scale the sprite should have to match the size of the area
	var sx = area_size.x / texture_size.x
	var sy = area_size.y / texture_size.y

	sprite.scale = Vector2(sx, sy)
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("viewArt", self, data)
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		emit_signal("closeArt", self, data)
	pass # Replace with function body.

func _on_Collected(_data):
	print("SUCCESSFULLY COLLECTED")
	Global._add_to_collected(data)
	queue_free()


