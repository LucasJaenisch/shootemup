extends KinematicBody2D

# Gameplay Variables
var speed = 100
var velocity = Vector2(0, 0)
var last_body_direction = Vector2()
var last_aim_direction = Vector2()
var can_move

var weapons = ["unarmed", "uzi", "shotgun", "magnun"]
var weapon_equiped = "unarmed"

# Color Settings
var body_color = Color(1,1,1)
var head_color = Color(1,1,1)
var upper_body_color = Color(1,1,1)
var lower_body_color = Color(1,1,1)
var color_picker_selection = Color(1,1,1)

# Loads a Texture for Default 
var head_sprite  = load("res://Textures/Head/hair0.png")
var upper_body_sprite = load("res://Textures/UpperBody/cloth0.png")
var base_upper_body_sprite = load("res://Textures/Base/upperbodyatlas.png")
var lower_body_sprite = load("res://Textures/LowerBody/cloth0.png")
var base_lower_boddy_sprite = load("res://Textures/Base/lowerbodyatlas.png")
var gun_sprite = load("res://Textures/Guns/unarmed.png")

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
	heads =  list_files_in_directory("res://Textures/Head/")
	lower_boddies =  list_files_in_directory("res://Textures/LowerBody/")
	upper_bodies =  list_files_in_directory("res://Textures/UpperBody/")
	guns = list_files_in_directory(("res://Textures/Guns/"))
	load_sprites(head_sprite, upper_body_sprite, base_upper_body_sprite, lower_body_sprite, base_lower_boddy_sprite, gun_sprite)
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		#print(event.scancode)
		if(event.scancode == 49 || event.scancode == 50 || event.scancode == 51 || event.scancode == 52 || event.scancode == 4 || event.scancode == 5):
			change_weapon(event.scancode)
		if(event.is_action("ui_select")):
			fire_weapon()
		
func change_weapon(input):
	if input == 49:
		guns_pos = 0
	elif input == 50:
		guns_pos = 1
	elif input == 51:
		guns_pos = 2
	elif input == 52:
		guns_pos = 3
	elif input == 4:
		if guns_pos < weapons.size() - 1:
			guns_pos += 1
		else:
			guns_pos = 0
	elif input == 5:
		if guns_pos > 0:
			guns_pos -= 1
		else:
			guns_pos = weapons.size() - 1
	# Calling the animations right here forces the loading to syncronize
	weapon_equiped = weapons[guns_pos]
	$GunSprite.texture = load("res://Textures/Guns/" + weapon_equiped + ".png")
	aim_animation("idleback")
	aim_animation("idleright")
	$Change_Guns.play()

func open_wardrobe():
	if Input.is_action_just_pressed("ui_focus_next"):
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
	head_sprite = load(heads[int(rand_range(0,heads.size() - 1))])
	$HeadSprite.texture = head_sprite
	upper_body_sprite = load(upper_bodies[int(rand_range(0,upper_bodies.size() - 1))])
	$UpperBodySprite.texture = upper_body_sprite
	lower_body_sprite = load(lower_boddies[int(rand_range(0,lower_boddies.size() - 1))])
	$LowerBodySprite.texture = lower_body_sprite
	$HeadSprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$UpperBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$LowerBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	body_color = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$BaseLowerBodySprite.modulate = body_color
	$BaseUpperBodySprite.modulate = body_color
	$Change_Clothes.play()
	
# Puts a LOADED texture in the sprites texture
func load_sprites(head, upper, base_upper, lower, base_lower, gun):
	$HeadSprite.texture = head
	$UpperBodySprite.texture = upper
	$BaseUpperBodySprite.texture = base_upper
	$LowerBodySprite.texture = lower
	$BaseLowerBodySprite.texture = base_lower
	$GunSprite.texture = gun
	
func aim():
	pass

func fire_weapon():
	if(weapon_equiped != "unarmed"):
		#weapon_manager.fire_weapon(last_aim_direction)
		$GunSprite/Gun_Fire_Points/Shotgun_Point.fire_weapon(last_aim_direction)
		#print("I m shooting")	
	else:
		pass
		#print("I dont have any gun equiped")
		
func move():
	pass

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
	$UpperBodyAnim.play(animation_name + str(guns_pos))
	$BaseUpperBodyAnim.play(animation_name + str(guns_pos))
	$HeadAnim.play(animation_name)
	$GunAnim.play(animation_name)

func move_animation(animation_name):
	#Play Specifc Animation for all the Animators
	$BaseLowerBodyAnim.play(animation_name)
	$LowerBodyAnim.play(animation_name)

func list_files_in_directory(path):
	# Returns an Array of Strings from the path of assets with .PNG extension from a Directory
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".import"):
			#print(path + file)
			files.append(path + file.replace(".import",""))
	dir.list_dir_end()
	
	return files

func _on_right_button_pressed():
	if $ButtonRight.rect_position.y == -14:
		if heads_pos < heads.size() -1 :
			heads_pos += 1
		else:
			heads_pos = 0
		head_sprite = load(heads[heads_pos])
		$HeadSprite.texture = head_sprite
	elif $ButtonRight.rect_position.y == -4:
		if upper_bodies_pos < upper_bodies.size() -1 :
			upper_bodies_pos += 1
		else:
			upper_bodies_pos = 0
		upper_body_sprite = load(upper_bodies[upper_bodies_pos])
		$UpperBodySprite.texture = upper_body_sprite
	elif $ButtonRight.rect_position.y == 6:
		if lower_boddies_pos < lower_boddies.size() -1 :
			lower_boddies_pos += 1
		else:
			lower_boddies_pos = 0
		lower_body_sprite = load(lower_boddies[lower_boddies_pos])
		$LowerBodySprite.texture = lower_body_sprite
	$Change_Clothes.play()

func _on_button_left_pressed():
	if $ButtonRight.rect_position.y == -14:
		if heads_pos > 0 :
			heads_pos -= 1
		else:
			heads_pos = heads.size() -1
		head_sprite = load(heads[heads_pos])
		$HeadSprite.texture = head_sprite
	elif $ButtonRight.rect_position.y == -4:
		if upper_bodies_pos > 0 :
			upper_bodies_pos -= 1
		else:
			upper_bodies_pos = upper_bodies.size() -1
		upper_body_sprite = load(upper_bodies[upper_bodies_pos])
		$UpperBodySprite.texture = upper_body_sprite
	elif $ButtonRight.rect_position.y == 6:
		if lower_boddies_pos > 0 :
			lower_boddies_pos -= 1
		else:
			lower_boddies_pos = lower_boddies.size() -1
		lower_body_sprite = load(lower_boddies[lower_boddies_pos])
		$LowerBodySprite.texture = lower_body_sprite
	$Change_Clothes.play()

