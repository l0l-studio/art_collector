extends Control

signal collected

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = get_node("ProgressGroup/Timer")
onready var pb =  get_node("ProgressGroup/CollectProgress")

onready var artwork_node =  get_node("ColorRect/ColorRect/Artwork_image")
onready var animation_node =  get_node("AnimationPlayer")

onready var title_node =  get_node("textInfo/Title")
onready var artist_node = get_node("textInfo/Artist")
onready var value_node = get_node("textInfo/Value")

var active_artwork = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("collected", pb, "_on_Progress_changed")
	WebMonetization.connect("on_monetization_started", self, "_on_monetization_started")
	WebMonetization.connect("on_monetization_stopped", self, "_on_monetization_stopped")
	if WebMonetization.is_paying():
		print("Should should high res")
		$ColorRect/ColorRect/PixelizeFilter.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(Input.is_action_pressed("collect"))
	#pass
	if Input.is_action_pressed("collect") and self.visible:
		$ProgressGroup.visible = true
		#emit_signal("collect", 1)
		if timer.time_left > 0:
			pb._on_Progress_changed(pb.get_max_duration() - timer.time_left)
	else:
		$ProgressGroup.visible = false
		pass
	#if Input.is_action_released("collect"):
	#	$ProgressGroup.visible = false
	#	print("stopped collecting")

#func _input(event):
#	if event.is_action_pressed("collect"):
#		$ProgressGroup.visible = true
#		emit_signal("collect", 1)
#		print("collecting")
#	if event.is_action_released("collect"):
#		$ProgressGroup.visible = false
#		print("stopped collecting")

func _input(event):
	if not self.visible:
		return
	if event.is_action_pressed("collect"):
		#TODO: use pause and add timer for each artwork.
		#if not timer.is_paused():
		timer.wait_time = pb.get_max_duration()
		timer.start()
		#else:
		#    print("UnPAused TIMER")
		#    timer.set_paused(false)
	elif event.is_action_released("collect"):
		#timer.set_paused(true)
		timer.stop()

func view_art_overlay(artworkNode, data):
	active_artwork = [artworkNode, data]

	artwork_node.texture = data.texture
	title_node.text = data.name
	value_node.text = String(data.value)

	timer.connect("timeout", self, "_on_Timeout")
	self.connect("collected", artworkNode, "_on_Collected")
	#receive data about the art and view accordingly
	pb.set_max_duration(data.time_to_collect)
	self.visible = not self.visible
	animation_node.play("Fade")

func close_art_overlay(artworkNode, data):
	animation_node.play_backwards("Fade")
	yield(animation_node, "animation_finished")

	self.visible = not self.visible

	timer.disconnect("timeout", self, "_on_Timeout")
	self.disconnect("collected", artworkNode, "_on_Collected")

	timer.stop()
	pb._on_Progress_changed(0)

func  _on_Timeout():
	emit_signal("collected", active_artwork)
	$Collected.play()

func _on_monetization_started():
	$ColorRect/ColorRect/PixelizeFilter.visible = false

func _on_monetization_stopped():
	$ColorRect/ColorRect/PixelizeFilter.visible = true
