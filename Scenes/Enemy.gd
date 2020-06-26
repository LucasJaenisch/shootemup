extends "res://Scenes/Character.gd"

var wander_time = 3

var target

func _ready():
	can_move = true
	randomize_character()
	
	
func _process(delta):
	move()
	animate()
	aim()

func move():
	velocity = get_local_mouse_position()
	if velocity.length() > 0:
		last_body_direction = velocity
		velocity = velocity.normalized() * speed	
	#position += velocity * delta
	move_and_slide(velocity)
	if false:
		yield(get_tree().create_timer(wander_time), "timeout")
		velocity.x = int(rand_range(-1, 1))
		velocity.y = int(rand_range(-1, 1))
		can_move = false
		print(velocity)
	.move()
	
func aim():
	last_aim_direction = get_local_mouse_position()
	
func seek(target):
	pass
