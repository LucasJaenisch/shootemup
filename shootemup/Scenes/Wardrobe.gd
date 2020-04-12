extends Node2D

var headassets = []
var upperbodyassets = []
var lowerbodyassets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	headassets = _list_files_in_directory("res://Animations/Head")
	
	for i in range(0,headassets.size()):
		print(headassets[i])
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
