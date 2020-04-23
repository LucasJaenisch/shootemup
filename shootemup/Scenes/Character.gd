extends Node2D

# Gameplay Variables
var speed = 100
var velocity
var last_body_direction = Vector2()
var last_aim_direction = Vector2()
var gun_type = 0

# Color Settings
var body_color = Color(1,1,1)
var head_color = Color(1,1,1)
var upper_body_color = Color(1,1,1)
var lower_body_color = Color(1,1,1)
var color_picker_selection = Color(1,1,1)

# Default Sprites Setup
var head_sprite  = "res://Textures/Head/hair0.png"
var upper_body_sprite = "res://Textures/UpperBody/cloth0.png"
var base_upper_body_sprite = "res://Textures/Base/upperbodyatlas.png"
var lower_body_sprite = "res://Textures/LowerBody/cloth0.png"
var base_lower_boddy_sprite = "res://Textures/Base/lowerbodyatlas.png"
var gun_sprite = "res://Textures/Guns/0.png"

# Array for Each Assets
var heads = []
var lower_boddies = []
var upper_bodies = []
var guns = []

# Positions of Assets in Array
var heads_pos = 0
var lower_boddies_pos = 0
var upper_bodies_pos = 0
var guns_pos = 0

func _ready():
	randomize()
	$ButtonLeft.hide()
	$ButtonRight.hide()
	$ColorPicker.hide()
	heads =  _list_files_in_directory("res://Textures/Head")
	lower_boddies =  _list_files_in_directory("res://Textures/LowerBody")
	upper_bodies =  _list_files_in_directory("res://Textures/UpperBody")
	guns = _list_files_in_directory(("res://Textures/Guns"))
	load_sprites()
	
func _process(delta):
	open_wardrobe()
	move(delta)
	animate()
	shoot()
	randomize_character()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		if gun_type == 0:
			gun_type = 2
		else:
			gun_type = 0
		$GunSprite.texture = load("Textures/Guns/" + guns[gun_type])
	
func open_wardrobe():
	if Input.is_action_just_pressed("ui_accept"):
		$ButtonRight.visible = ! $ButtonRight.visible
		$ButtonLeft.visible = ! $ButtonLeft.visible
		$ColorPicker.visible = ! $ColorPicker.visible
		speed = 100
	if $ButtonLeft.visible:
		speed = 0
		dress_and_paint()
	
func dress_and_paint():
	if Input.is_action_pressed("mouse_left"):
		color_picker_selection = $ColorPicker.color
		if $ButtonRight.rect_position.y == -24:
			body_color = color_picker_selection
			$BaseUpperBodySprite.modulate = body_color
			$BaseLowerBodySprite.modulate = body_color
		if $ButtonRight.rect_position.y == -14 :
			head_color = color_picker_selection
			$HeadSprite.modulate = head_color
		if $ButtonRight.rect_position.y == -4 :
			upper_body_color = color_picker_selection
			$UpperBodySprite.modulate = upper_body_color
		if $ButtonRight.rect_position.y == 6 :
			lower_body_color = color_picker_selection
			$LowerBodySprite.modulate = lower_body_color
	
	if Input.is_action_just_pressed("ui_right"):
		$ButtonRight.emit_signal("pressed")
		
	if Input.is_action_just_pressed("ui_left"):
		$ButtonLeft.emit_signal("pressed")
		
	if Input.is_action_just_pressed("ui_down"):
		if $ButtonRight.rect_position.y < 6 :
			$ButtonRight.rect_position.y += 10
			$ButtonLeft.rect_position.y += 10
		else:
			$ButtonRight.rect_position.y = -24
			$ButtonLeft.rect_position.y = -24
			
	if Input.is_action_just_pressed("ui_up"):
		if $ButtonRight.rect_position.y > -24 :
			$ButtonRight.rect_position.y -= 10
			$ButtonLeft.rect_position.y -= 10
		else:
			$ButtonRight.rect_position.y = 6
			$ButtonLeft.rect_position.y = 6

func randomize_character():
	if Input.is_action_just_pressed("mouse_right"):
		$HeadSprite.texture = load("res://Textures/Head/" + heads[int(rand_range(0,heads.size() - 1))])
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upper_bodies[int(rand_range(0,upper_bodies.size() - 1))])
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lower_boddies[int(rand_range(0,lower_boddies.size() - 1))])
		$HeadSprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
		$UpperBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
		$LowerBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
		body_color = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
		$BaseLowerBodySprite.modulate = body_color
		$BaseUpperBodySprite.modulate = body_color
	
func load_sprites():
	$HeadSprite.texture = load(head_sprite)
	$UpperBodySprite.texture = load(upper_body_sprite)
	$BaseUpperBodySprite.texture = load(base_upper_body_sprite)
	$LowerBodySprite.texture = load(lower_body_sprite)
	$BaseLowerBodySprite.texture = load(base_lower_boddy_sprite)
	$GunSprite.texture = load(gun_sprite)

func shoot():
	if Input.is_action_just_pressed("shoot_right"):
		last_aim_direction.x = 1
		last_aim_direction.y = 0
		$GunSprite/Gun_Fire_Points/Shotgun_Point.fire_weapon(last_aim_direction)
	elif Input.is_action_just_pressed("shoot_left"):
		last_aim_direction.x = -1
		last_aim_direction.y = 0
		$GunSprite/Gun_Fire_Points/Shotgun_Point.fire_weapon(last_aim_direction)
	elif Input.is_action_just_pressed("shoot_down"):
		last_aim_direction.x = 0
		last_aim_direction.y = 1
		$GunSprite/Gun_Fire_Points/Shotgun_Point.fire_weapon(last_aim_direction)
	elif Input.is_action_just_pressed("shoot_up"):
		last_aim_direction.x = 0
		last_aim_direction.y = -1
		$GunSprite/Gun_Fire_Points/Shotgun_Point.fire_weapon(last_aim_direction)
		
func move(delta):
	velocity = Vector2(0,0)
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
		
	position += velocity * delta

func animate():
	# Logic to Cal Specific Upper Body Animations of the Character
	if last_aim_direction.x != 0:
		$BaseUpperBodySprite.flip_h = last_aim_direction.x < 0
		$UpperBodySprite.flip_h = last_aim_direction.x < 0
		$HeadSprite.flip_h = last_aim_direction.x < 0
		$GunSprite.flip_h = last_aim_direction.x < 0
		aim_animation("idleright")
	elif last_aim_direction.y > 0:
		aim_animation("idlefront")
	elif last_aim_direction.y < 0:
		aim_animation("idleback")
	#else:
	#	if last_aim_direction.y < 0:
	#		aim_animation("walkright")
	#	elif last_aim_direction.y > 0:
	#		aim_animation("walkdown")
	#	elif last_aim_direction.x != 0:
	#		aim_animation("walkup")
	
	# Logic to Cal Specific Lower Body Animations of the Character
	if velocity.x != 0:
		$BaseLowerBodySprite.flip_h = velocity.x < 0
		$LowerBodySprite.flip_h = velocity.x < 0
		move_animation("walkright")
	elif velocity.y > 0:
		move_animation("walkdown")
	elif velocity.y < 0:
		move_animation("walkup")
	else:
		if last_body_direction.y < 0:
			move_animation("idleback")
		elif last_body_direction.y > 0:
			move_animation("idlefront")
		elif last_body_direction.x != 0:
			move_animation("idleright")

func aim_animation(animation_name):
	#Play Specifc Animation for all the Animators
	$UpperBodyAnim.play(animation_name + str(gun_type))
	$BaseUpperBodyAnim.play(animation_name + str(gun_type))
	$HeadAnim.play(animation_name)
	$GunAnim.play(animation_name)

func move_animation(animation_name):
	#Play Specifc Animation for all the Animators
	$BaseLowerBodyAnim.play(animation_name)
	$LowerBodyAnim.play(animation_name)

func _list_files_in_directory(path):
	# Returns an Array of Files with the .PNG extension from a Directory
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".png"):
			files.append(file)
	dir.list_dir_end()
	
	return files

func _on_right_button_pressed():
	if $ButtonRight.rect_position.y == -14:
		if heads_pos < heads.size() -1 :
			heads_pos += 1
		else:
			heads_pos = 0
		$HeadSprite.texture = load("res://Textures/Head/" + heads[heads_pos])
	elif $ButtonRight.rect_position.y == -4:
		if upper_bodies_pos < upper_bodies.size() -1 :
			upper_bodies_pos += 1
		else:
			upper_bodies_pos = 0
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upper_bodies[upper_bodies_pos])
	elif $ButtonRight.rect_position.y == 6:
		if lower_boddies_pos < lower_boddies.size() -1 :
			lower_boddies_pos += 1
		else:
			lower_boddies_pos = 0
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lower_boddies[lower_boddies_pos])

func _on_button_left_pressed():
	if $ButtonRight.rect_position.y == -14:
		if heads_pos > 0 :
			heads_pos -= 1
		else:
			heads_pos = heads.size() -1
		$HeadSprite.texture = load("res://Textures/Head/" + heads[heads_pos])
	elif $ButtonRight.rect_position.y == -4:
		if upper_bodies_pos > -1 :
			upper_bodies_pos -= 1
		else:
			upper_bodies_pos = upper_bodies.size() -1
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upper_bodies[upper_bodies_pos])
	elif $ButtonRight.rect_position.y == 6:
		if lower_boddies_pos > -1 :
			lower_boddies_pos -= 1
		else:
			lower_boddies_pos = lower_boddies.size() -1
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lower_boddies[lower_boddies_pos])
