extends Node2D

var health = 100

func _ready():
#	$RigidBody2D/CollisionShape2D.connect("body_enter", self, "_on_enemy_body_enter")
	pass

func _on_Enemy_area_entered(area):
	#take_damage(10)
	pass # Replace with function body.

func take_damage(amount):
	if health - amount <= 0:
		die()
	else:
		health -= amount
	print("I've took " + str(amount) + " damage")
	print("My health now is: " + str(health))

func die():
	print("I'm dead!")
	queue_free()
