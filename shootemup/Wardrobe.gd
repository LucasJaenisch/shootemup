extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open_wardrobe():
	if Input.is_action_just_pressed("ui_accept"):
		$ButtonRight.visible = ! $ButtonRight.visible
		$ButtonLeft.visible = ! $ButtonLeft.visible
		$ColorPicker.visible = ! $ColorPicker.visible
	if $ButtonLeft.visible:
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
