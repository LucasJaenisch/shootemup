extends Node2D

var BULLET_SPEED = 300

var BULLET_DAMAGE = 15

var KILL_TIMER = 2
var timer = 0

var hit_something = false

func _ready():
	#$Area2D.connect("body_entered", self, "collided")
	pass

func _physics_process(delta):
	var forward_dir = global_transform.x.normalized()
	global_translate(forward_dir * BULLET_SPEED * delta)
	
	timer += delta
	if timer >= KILL_TIMER:
		queue_free()

func _on_Bullet_area_entered(area):
	print("I ve hit an " + area.get_name())
	if area.get_name() == "Enemy":
		area.take_damage(BULLET_DAMAGE)
	queue_free()
