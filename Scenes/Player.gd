extends "res://Scenes/Character.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	animate()
	aim()
	open_wardrobe()
	
func move():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		last_body_direction = velocity
		velocity = velocity.normalized() * speed
		
	move_and_slide(velocity)
	.move()

func aim():
	if Input.is_action_pressed("shoot_right"):
		last_aim_direction = Vector2.RIGHT
	if Input.is_action_pressed("shoot_left"):
		last_aim_direction = Vector2.LEFT
	if Input.is_action_pressed("shoot_down"):
		last_aim_direction = Vector2.DOWN
	if Input.is_action_pressed("shoot_up"):
		last_aim_direction = Vector2.UP
	.aim()
