extends Node2D

var speed = 100
var velocity = Vector2()
var lastdirection = Vector2()

export var bodycolor = Vector3()
export var haircolor = Vector3()

var headsprite  = ""
var upperbodysprite = ""
var baseupperbodysprite = "res://Textures/Base/upperbodyatlas.png"
var lowerbodysprite = ""
var baseloweboddysprite = "res://Textures/Base/lowerbodyatlas.png"
var gunsprite = "res://Textures/Guns/shotgun.png"

var headpieces = []
var upperbodypieces = []
var lowerbodypieces = []
var gunpieces = []

var headpiecesposition = 0
var lowerbodypiecesposition = 0
var upperbodypiecesposition = 0
var gunpiecesposition = 0

func _ready():
	$ButtonLeft.hide()
	$ButtonRight.hide()
	$ColorPicker.hide()
	headpieces =  _list_files_in_directory("res://Textures/Head")
	lowerbodypieces =  _list_files_in_directory("res://Textures/LowerBody")
	upperbodypieces =  _list_files_in_directory("res://Textures/UpperBody")
	gunpieces = _list_files_in_directory(("res://Textures/Guns"))
	randomize()
	_load_sprites(headsprite, upperbodysprite, baseupperbodysprite, lowerbodysprite, baseloweboddysprite, gunsprite)
	_colorize()
	
func _process(delta):
	_open_wardrobe()
	_move_and_animate(delta)
	
	

func _open_wardrobe():
	if Input.is_action_just_pressed("ui_accept"):
		$ButtonRight.visible = ! $ButtonRight.visible
		$ButtonLeft.visible = ! $ButtonLeft.visible
		#$ColorPicker.visible = ! $ColorPicker.visible
		speed = 100
		
	if $ButtonLeft.visible:
		speed = 0
		_dress()
	
	
func _dress():
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
	else:
		if lastdirection.y < 0:
			#check upper body
			$UpperBodyAnim.play("idlebackdefault")
			$BaseUpperBodyAnim.play("idlebackdefault")
			$HeadAnim.play("idleback")
			$BaseLowerBodyAnim.play("idleback")
			$LowerBodyAnim.play("idleback")
			$GunAnim.play("idleback")
		else:
			#check upper body animation
			$BaseUpperBodyAnim.play("idlefrontdefault")
			$UpperBodyAnim.play("idlefrontdefault")
			$HeadAnim.play("idlefront")
			$BaseLowerBodyAnim.play("idlefront")
			$LowerBodyAnim.play("idlefront")
			$GunAnim.play("idlefront")
		
	position += velocity * delta
		
	if velocity.x != 0:
		#check upper body animation
		$BaseUpperBodyAnim.play("walkrightdefault")
		$UpperBodyAnim.play("walkrightdefault")
		$HeadAnim.play("walkright")
		$BaseLowerBodyAnim.play("walkright")
		$LowerBodyAnim.play("walkright")
		$GunAnim.play("walkright")
		
		#flipsstuff
		
		
		$BaseUpperBodySprite.flip_v = false
		$BaseUpperBodySprite.flip_h = velocity.x < 0
		$UpperBodySprite.flip_v = false
		$UpperBodySprite.flip_h = velocity.x < 0
		$HeadSprite.flip_v = false
		$HeadSprite.flip_h = velocity.x < 0
		$BaseLowerBodySprite.flip_v = false
		$BaseLowerBodySprite.flip_h = velocity.x < 0
		$LowerBodySprite.flip_v = false
		$LowerBodySprite.flip_h = velocity.x < 0
		$GunSprite.flip_v = false
		$GunSprite.flip_h = velocity.x < 0
		
	elif velocity.y > 0:
		#check upper body
		$BaseUpperBodyAnim.play("walkdowndefault")
		$UpperBodyAnim.play("walkdowndefault")
		$HeadAnim.play("walkright")
		$BaseLowerBodyAnim.play("walkdown")
		$LowerBodyAnim.play("walkdown")
	elif velocity.y < 0:
		#check upper body
		$BaseUpperBodyAnim.play("walkupdefault")
		$UpperBodyAnim.play("walkupdefault")
		$LowerBodyAnim.play("walkup")
		$BaseLowerBodyAnim.play("walkup")
		$HeadAnim.play("walkup")

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
		if headpiecesposition < headpieces.size() -1 :
			headpiecesposition += 1
		else:
			headpiecesposition = 0
		$HeadSprite.texture = load("res://Textures/Head/" + headpieces[headpiecesposition])
		#print(headpiecesposition)
	elif $ButtonRight.rect_position.y == -4:
		if upperbodypiecesposition < upperbodypieces.size() -1 :
			upperbodypiecesposition += 1
		else:
			upperbodypiecesposition = 0
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upperbodypieces[upperbodypiecesposition])
	else:
		if lowerbodypiecesposition < lowerbodypieces.size() -1 :
			lowerbodypiecesposition += 1
		else:
			lowerbodypiecesposition = 0
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerbodypieces[lowerbodypiecesposition])

func _on_button_left_pressed():
	if $ButtonRight.rect_position.y == -14:
		if headpiecesposition > 0 :
			headpiecesposition -= 1
		else:
			headpiecesposition = headpieces.size() -1
		$HeadSprite.texture = load("res://Textures/Head/" + headpieces[headpiecesposition])
		#print(headpiecesposition)
	elif $ButtonRight.rect_position.y == -4:
		if upperbodypiecesposition > -1 :
			upperbodypiecesposition -= 1
		else:
			upperbodypiecesposition = upperbodypieces.size() -1
		$UpperBodySprite.texture = load("res://Textures/UpperBody/" + upperbodypieces[upperbodypiecesposition])
	else:
		if lowerbodypiecesposition > -1 :
			lowerbodypiecesposition -= 1
		else:
			lowerbodypiecesposition = lowerbodypieces.size() -1
		$LowerBodySprite.texture = load("res://Textures/LowerBody/" + lowerbodypieces[lowerbodypiecesposition])
