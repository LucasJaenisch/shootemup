extends Node2D

var character_scene = preload("Scenes/Character.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_root = get_tree().root.get_children()[0]
	var character = character_scene.instance()
	scene_root.add_child(character)
	pass # Replace with function body.
