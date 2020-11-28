extends Node2D

var max_duration = 0 setget set_max_duration
var progress = 0 setget set_progress

func set_max_duration(value):
	max_duration = value
	$TextureProgress.max_value = value

func set_progress(value):
	progress = value
	$TextureProgress.value = value
	
func get_max_duration():
	return self.max_duration
	
func _on_Progress_changed(new_progress):
	self.progress = new_progress
	#	if self.progress < max_duration:
	#		self.progress = self.progress + new_progress
	#	else:
	#		set_progress(0)

func _on_progress_done():
	queue_free()
