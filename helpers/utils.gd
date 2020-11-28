extends Node

const TYPE_MAP = {
		".png": ".stex"
		}

static func get_input_direction(event = Input):
	return Vector2(
			float(event.is_action_pressed("move_right")) - float(event.is_action_pressed("move_left")),
			float(event.is_action_pressed("move_down")) - float(event.is_action_pressed("move_up"))
		).normalized()

# get items in directory
# https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
static func list_files_in_directory(path, identifier, type):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	print(TYPE_MAP[type])

	while true:
		var file = dir.get_next()
		var filename = file.rsplit("-")[0]
		if file == "": 
			break
		elif (not file.begins_with(".") and file.ends_with(TYPE_MAP[type])) and (filename.begins_with(identifier) and filename.ends_with(type)):
			files.append(file)
		#do the search for files in the .import directory

	dir.list_dir_end()
	
	print("This is from UTILS", files)

	return files

static func get_randomized_art_list(identifier, type):
	var art_list = list_files_in_directory("res://.import/", identifier, type)
	randomize()
	art_list.shuffle()
	return art_list

static func string_to_array(string):
	var res = []
	for i in string:
		res.append(i)
	return res

