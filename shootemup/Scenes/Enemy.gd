extends Node2D

var health = 100

func _ready():
#	$RigidBody2D/CollisionShape2D.connect("body_enter", self, "_on_enemy_body_enter")
	pass

func take_damage(value):
	health -= value



func _on_Enemy_area_entered(area):
	queue_free()
	pass # Replace with function body.
