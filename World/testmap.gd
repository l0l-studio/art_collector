extends Node2D

#onready var _transition_rect := get_node("ArtInfoOverlay/SceneTransition")
onready var _transition_rect := get_node("SceneTransition")

const Game_Over_Page = preload("res://Screens/GameOver.tscn")
const ARTWORK = preload("res://World/ArtWork.tscn")

var SECRET = "bit.ly/art_collector_stash"

var settings = {
		"to_explore": 5,
		"to_collect": 2.4,
		"capacity": 6,
		"spawn_points": [
			[282, 298],
			[992, -108],
			[1005, 325],
			[589, 541],
			[207, 868],
			[202, 1342],
			[621, 1262],
			[1133, 1039],
			[1080, 1359],
			[1351, 1574],
			[1317, 1258],
		]
		}

var score = 0
var art

var game_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_game()
	$AudioStreamPlayer2D.playing = true
	game_timer = get_tree().create_timer(settings.to_collect*60)
	yield(game_timer, "timeout")
	print("game OVER")
	game_over()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_left = int(round(game_timer.get_time_left()))
	Global._update_time(time_left)
	if time_left == 11:
		$Countdown.play()
	pass

func initialize_game():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	Global.set_capacity(settings.capacity)
	art = utils.get_randomized_art_list("_artworks_", ".jpg")
	
	SECRET = utils.string_to_array(SECRET)
	
	for i in range(SECRET.size()):
		SECRET[i] = str(i, SECRET[i])
	randomize()
	SECRET.shuffle()
	
	var rand = rng.randi_range(0, settings.spawn_points.size()-1)
	var spawn_point = settings.spawn_points[rand]
	$Player.position = Vector2(spawn_point[0], spawn_point[1])
	
	self.rotation_degrees = rng.randi_range(-360, 0)

	var artInfoOverlay = get_node("ArtInfoOverlay/ArtInfo")
	var hud = get_node("HUDLayer/HUD")
	
	artInfoOverlay.connect("collected", hud, "_on_Collected")
	hud._initialize()

	var artworks = self.get_node("ArtWorks").get_children()
	#for i in range(artworks.size()):
	for i in range(art.size()):
		var artwork_node = artworks[i] 
		var art_image = ResourceLoader.load("res://.import/" + art[i])

		artwork_node.initialize(SECRET[i], art_image)

		#artwork_node.connect("viewArt", self, "handle_view_art")
		artwork_node.connect("viewArt", artInfoOverlay, "view_art_overlay")
		artwork_node.connect("closeArt", artInfoOverlay, "close_art_overlay")
		
	get_game_targets(artworks)

func game_over():
	_transition_rect.transition_to(Game_Over_Page)
	pass

func get_game_targets(artworks):
	var artworks_data = []
	for i in artworks:
		var data = i.get_data()
		if data.get("value"):
			artworks_data.append(i.get_data())
	
	artworks_data.sort_custom(ArtworkSort, "sort_value_desc")
	
	Global.set_targets(artworks_data.slice(0,5,1))
	
func _on_ArtInfo_collected(artwork):
	Global._add_score(artwork[1].value)
	var current_capacity = Global._decrement_capacity()
	
	if current_capacity == 0:
		game_over()
	#print(Global._score)
	pass # Replace with function body.

class ArtworkSort:
	static func sort_value_desc(a, b):
		if a.value > b.value:
			return true
		return false
