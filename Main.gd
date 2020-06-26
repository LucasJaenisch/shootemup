extends Node2D

var player_scene = preload("Scenes/Player.tscn")
var enemy_scene = preload("Scenes/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_root = get_tree().root.get_children()[0]
	scene_root = get_tree().root.get_children()[0]
	var player = player_scene.instance()
	var enemy = enemy_scene.instance()
	scene_root.add_child(player)
	scene_root.add_child(enemy)
	enemy.position.x = 10
	enemy.position.y = 30
	pass # Replace with function body.
