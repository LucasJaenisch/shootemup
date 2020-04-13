extends Node2D

var speed = 100
var velocity = Vector2()
var lastdirection = Vector2()
var guntype = 0

var bodycolor = Vector3()
var haircolor = Vector3()
var upperbodycolor = Vector3()
var lowerbodycolor = Vector3()

var headsprite  = "res://Textures/Head/hair0.png"
var upperbodysprite = "res://Textures/UpperBody/cloth0.png"
var baseupperbodysprite = "res://Textures/Base/upperbodyatlas.png"
var lowerbodysprite = "res://Textures/LowerBody/cloth0.png"
var baseloweboddysprite = "res://Textures/Base/lowerbodyatlas.png"
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
	$ButtonLeft.hide()
	$ButtonRight.hide()
	$ColorPicker.hide()
	heads =  _list_files_in_directory("res://Textures/Head")
	lowerboddies =  _list_files_in_directory("res://Textures/LowerBody")
	upperbodies =  _list_files_in_directory("res://Textures/UpperBody")
	guns = _list_files_in_directory(("res://Textures/Guns"))
	randomize()
	_load_sprites(headsprite, upperbodysprite, baseupperbodysprite, lowerbodysprite, baseloweboddysprite, gunsprite)
	_colorize()
	
func _process(delta):
	_open_wardrobe()
	_move_and_animate(delta)
	if Input.is_action_just_pressed("ui_focus_next"):
		if guntype < guns.size() -1:
			guntype += 1
		else:
			guntype = 0
		$GunSprite.texture = load("Textures/Guns/" + guns[guntype])
		print(guns[guntype])
	
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
	$BaseUpperBodySprite.modulate = Color(bodycolor.x, bodycolor.y, bodycolor.z)
	$BaseLowerBodySprite.modulate = Color(bodycolor.x, bodycolor.y, bodycolor.z)
	if Input.is_action_pressed("mouse_left"):
		bodycolor.x = $ColorPicker.color.r
		bodycolor.y = $ColorPicker.color.g
		bodycolor.z = $ColorPicker.color.b
	
	if Input.is_action_just_pressed("ui_right"):
		$ButtonRight.emit_signal("pressed")
		
	if Input.is_action_just_pressed("ui_left"):
		$ButtonLeft.emit_signal("pressed")
		
	if Input.is_action_just_pressed("ui_down"):
		if $ButtonRight.rect_position.y < 6 :
			$ButtonRight.rect_position.y += 10
			$ButtonLeft.rect_position.y += 10
		else:
			$ButtonRight.rect_position.y = -14
			$ButtonLeft.rect_position.y = -14
			
	if Input.is_action_just_pressed("ui_up"):
		if $ButtonRight.rect_position.y > -14 :
			$ButtonRight.rect_position.y -= 10
			$ButtonLeft.rect_position.y -= 10
		else:
			$ButtonRight.rect_position.y = 6
			$ButtonLeft.rect_position.y = 6
	

func _load_sprites(head, upperbody, baseupperbody, lowerbody, baselowerbody, gun):
	$HeadSprite.texture = load(head)
	$UpperBodySprite.texture = load(upperbody)
	$BaseUpperBodySprite.texture = load(baseupperbody)
	$LowerBodySprite.texture = load(lowerbody)
	$BaseLowerBodySprite.texture = load(baselowerbody)
	$GunSprite.texture = load(gun)

func _colorize():
	if  randf ( ) > 0.5:
		$BaseUpperBodySprite.modulate = Color(0.37, 0.18, 0.11)
		$BaseLowerBodySprite.modulate = Color(0.37, 0.18, 0.11)
	else:
		$BaseUpperBodySprite.modulate = Color(0.8, 0.58, 0.53)
		$BaseLowerBodySprite.modulate = Color(0.8, 0.58, 0.53)
		
	bodycolor.x = $BaseUpperBodySprite.modulate.r
	bodycolor.y = $BaseUpperBodySprite.modulate.g
	bodycolor.z = $BaseUpperBodySprite.modulate.b

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
		_animate("walkright")
		$BaseUpperBodySprite.flip_h = velocity.x < 0
		$UpperBodySprite.flip_h = velocity.x < 0
		$HeadSprite.flip_h = velocity.x < 0
		$BaseLowerBodySprite.flip_h = velocity.x < 0
		$LowerBodySprite.flip_h = velocity.x < 0
		$GunSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		_animate("walkdown")
	elif velocity.y < 0:
		_animate("walkup")
	else:
		if lastdirection.y < 0:
			_animate("idleback")
		elif lastdirection.y > 0:
			_animate("idlefront")
		elif lastdirection.x != 0:
			_animate("idleright")
	
	position += velocity * delta

func _animate(animationname):
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
	else:
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
	else:
		if lowerboddiespos > -1 :
			lowerboddiespos -= 1
		else:
			lowerboddiespos = lowerboddies.size() -1
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerboddies[lowerboddiespos])
