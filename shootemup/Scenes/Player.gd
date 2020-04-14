extends Node2D

var speed = 100
var velocity = Vector2()
var lastdirection = Vector2()
var guntype = 0

var bodycolor = Color(1,1,1)
var headcolor = Color(1,1,1)
var upperbodycolor = Color(1,1,1)
var lowerbodycolor = Color(1,1,1)
var colorpickerselection = Color(1,1,1)

var headsprite  = "res://Textures/Head/hair0.png"
var upperbodysprite = "res://Textures/UpperBody/cloth0.png"
var baseupperbodysprite = "res://Textures/Base/upperbodyatlas.png"
var lowerbodysprite = "res://Textures/LowerBody/cloth0.png"
var baselowerboddysprite = "res://Textures/Base/lowerbodyatlas.png"
var gunsprite = "res://Textures/Guns/nogun.png"

var heads = []
var lowerboddies = []
var upperbodies = []
var guns = []

var headspos = 0
var lowerboddiespos = 0
var upperbodiespos = 0
var gunspos = 0

func _ready():
	randomize()
	$ButtonLeft.hide()
	$ButtonRight.hide()
	$ColorPicker.hide()
	heads =  _list_files_in_directory("res://Textures/Head")
	lowerboddies =  _list_files_in_directory("res://Textures/LowerBody")
	upperbodies =  _list_files_in_directory("res://Textures/UpperBody")
	guns = _list_files_in_directory(("res://Textures/Guns"))
	_load_sprites()
	
func _process(delta):
	_open_wardrobe()
	_move_and_animate(delta)
	
	if Input.is_action_just_pressed("mouse_right"):
		_randomize_character()
		pass
	
	if Input.is_action_just_pressed("ui_focus_next"):
		if guntype == 0:
			guntype = 2
		else:
			guntype = 0
		$GunSprite.texture = load("Textures/Guns/" + guns[guntype])
	
func _open_wardrobe():
	if Input.is_action_just_pressed("ui_accept"):
		$ButtonRight.visible = ! $ButtonRight.visible
		$ButtonLeft.visible = ! $ButtonLeft.visible
		$ColorPicker.visible = ! $ColorPicker.visible
		speed = 100
	if $ButtonLeft.visible:
		speed = 0
		_dress_and_paint()
	
func _dress_and_paint():
	if Input.is_action_pressed("mouse_left"):
		colorpickerselection = $ColorPicker.color
		if $ButtonRight.rect_position.y == -24:
			bodycolor = colorpickerselection
			$BaseUpperBodySprite.modulate = bodycolor
			$BaseLowerBodySprite.modulate = bodycolor
		if $ButtonRight.rect_position.y == -14 :
			headcolor = colorpickerselection
			$HeadSprite.modulate = headcolor
		if $ButtonRight.rect_position.y == -4 :
			upperbodycolor = colorpickerselection
			$UpperBodySprite.modulate = upperbodycolor
		if $ButtonRight.rect_position.y == 6 :
			lowerbodycolor = colorpickerselection
			$LowerBodySprite.modulate = lowerbodycolor
	
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

func _randomize_character():
	$HeadSprite.texture = load("res://Textures/Head/" + heads[int(rand_range(0,heads.size() - 1))])
	$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upperbodies[int(rand_range(0,upperbodies.size() - 1))])
	$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerboddies[int(rand_range(0,lowerboddies.size() - 1))])
	$HeadSprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$UpperBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$LowerBodySprite.modulate = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	bodycolor = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	$BaseLowerBodySprite.modulate = bodycolor
	$BaseUpperBodySprite.modulate = bodycolor
	
func _load_sprites():
	$HeadSprite.texture = load(headsprite)
	$UpperBodySprite.texture = load(upperbodysprite)
	$BaseUpperBodySprite.texture = load(baseupperbodysprite)
	$LowerBodySprite.texture = load(lowerbodysprite)
	$BaseLowerBodySprite.texture = load(baselowerboddysprite)
	$GunSprite.texture = load(gunsprite)

func _move_and_animate(delta):
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
		lastdirection = velocity
		velocity = velocity.normalized() * speed
		
	if velocity.x != 0:
		_play_animation("walkright")
		$BaseUpperBodySprite.flip_h = velocity.x < 0
		$UpperBodySprite.flip_h = velocity.x < 0
		$HeadSprite.flip_h = velocity.x < 0
		$BaseLowerBodySprite.flip_h = velocity.x < 0
		$LowerBodySprite.flip_h = velocity.x < 0
		$GunSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		_play_animation("walkdown")
	elif velocity.y < 0:
		_play_animation("walkup")
	else:
		if lastdirection.y < 0:
			_play_animation("idleback")
		elif lastdirection.y > 0:
			_play_animation("idlefront")
		elif lastdirection.x != 0:
			_play_animation("idleright")
	
	position += velocity * delta

func _play_animation(animationname):
	$UpperBodyAnim.play(animationname + str(guntype))
	$BaseUpperBodyAnim.play(animationname + str(guntype))
	$HeadAnim.play(animationname)
	$BaseLowerBodyAnim.play(animationname)
	$LowerBodyAnim.play(animationname)
	$GunAnim.play(animationname)

func _list_files_in_directory(path):
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
		if headspos < heads.size() -1 :
			headspos += 1
		else:
			headspos = 0
		$HeadSprite.texture = load("res://Textures/Head/" + heads[headspos])
	elif $ButtonRight.rect_position.y == -4:
		if upperbodiespos < upperbodies.size() -1 :
			upperbodiespos += 1
		else:
			upperbodiespos = 0
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upperbodies[upperbodiespos])
	elif $ButtonRight.rect_position.y == 6:
		if lowerboddiespos < lowerboddies.size() -1 :
			lowerboddiespos += 1
		else:
			lowerboddiespos = 0
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerboddies[lowerboddiespos])

func _on_button_left_pressed():
	if $ButtonRight.rect_position.y == -14:
		if headspos > 0 :
			headspos -= 1
		else:
			headspos = heads.size() -1
		$HeadSprite.texture = load("res://Textures/Head/" + heads[headspos])
	elif $ButtonRight.rect_position.y == -4:
		if upperbodiespos > -1 :
			upperbodiespos -= 1
		else:
			upperbodiespos = upperbodies.size() -1
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upperbodies[upperbodiespos])
	elif $ButtonRight.rect_position.y == 6:
		if lowerboddiespos > -1 :
			lowerboddiespos -= 1
		else:
			lowerboddiespos = lowerboddies.size() -1
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerboddies[lowerboddiespos])
