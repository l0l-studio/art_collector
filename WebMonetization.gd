extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal on_monetization_started
signal on_monetization_stopped

var _paying: bool
var _poll: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if JavaScript.eval("(document.monetization !== null);"):
		_poll = Timer.new()
		add_child(_poll)
		_poll.connect("timeout", self, "_on_poll_timeout")
		_poll.one_shot = false
		_poll.start(1)
	pass # Replace with function body.

func _on_poll_timeout() -> void:
	if JavaScript.eval("(document.monetization.state === 'started');"):
		if not _paying:
			emit_signal("on_monetization_started")
			_paying = true
			#_poll.queue_free()
	elif _paying:
		_paying = false
		emit_signal("on_monetization_stopped")

func is_paying() -> bool:
	return _paying
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
