extends "res://Characters/character.gd"

signal speed_changed(speed, max_speed)

const MoveGroundStrategy = preload("res://Characters/Player/move-grounds-strategy.gd")

enum States {
	IDLE,
	WALK,
	RUN,
	BUMP,
	JUMP,
	FALL,
	RESPAWN
}

enum Events {
	INVALID = -1,
	STOP,
	IDLE,
	WALK,
	RUN,
	BUMP,
	JUMP,
	FALL,
	RESPAWN
}

const SPEED = {
	States.WALK: 250,
	States.RUN: 300,
}

const MOVE_STRATEGY = {
	States.WALK: MoveGroundStrategy,
	States.RUN: MoveGroundStrategy,
}

var _speed = 0 setget _set_speed
var _max_speed = 0
var _velocity = Vector2()
var _collision_normal = Vector2()
var _last_input_direction = Vector2()

func _init() -> void:
	_transitions = {
		[States.IDLE, Events.WALK]: States.WALK,
		[States.IDLE, Events.RUN]: States.RUN,
		[States.WALK, Events.STOP]: States.IDLE,
		[States.WALK, Events.RUN]: States.RUN,
		[States.RUN, Events.STOP]: States.IDLE,
		[States.RUN, Events.WALK]: States.WALK,
	}

func _ready() -> void:
	connect("speed_changed", $DirectionVisualizer, "_on_Move_speed_changed")
	#$DirectionVisualizer._setup(self)
	
func _physics_process(delta):
	var input = get_raw_input()
	var event = decode_raw_input(input)
	
	change_state(event)
	
	match state:
		States.WALK, States.RUN:
			var params = MOVE_STRATEGY[state].go(input.direction, _speed, _velocity)
			self._speed = params.speed
			_velocity = params.velocity
			_move()

func _move():
	move_and_slide(_velocity)
	
	var viewport_size = get_viewport().size
	#for i in range(2):
	#	if position[i] < 0:
	#		position[i] = viewport_size[i]
	#	if position[i] > viewport_size[i]:
	#		position[i] = 0

	
func enter_state():
	match state:
		States.IDLE:
			$AnimationPlayer.play("BASE")
			_velocity = Vector2()
			_max_speed =  SPEED[States.WALK]
			self._speed = 0
		States.WALK, States.RUN:
			_max_speed = SPEED[state]
			self._speed = _max_speed
			$AnimationPlayer.play("move")
			

static func get_raw_input():
	return {
		direction = utils.get_input_direction(),
		is_running = Input.is_action_pressed("run")
		
	}

static func decode_raw_input(input):
	var event = Events.INVALID

	if input.direction == Vector2():
		event = Events.STOP
	elif input.is_running:
		event = Events.RUN
	else: 
		event = Events.WALK
	
	return event
	

func _set_speed(new_speed):
	if _speed == new_speed:
		return
	_speed = new_speed
	emit_signal("speed_changed", _speed, SPEED[States.RUN])
