extends Position2D

var ammo_in_weapon = 10
var spare_ammo = 20

var bullet_origin = Vector2()

const AMMO_IN_MAG = 10

const DAMAGE = 15

const CAN_RELOAD = true
const CAN_REFILL = true

const GUN_OFFSET_X = Vector2(17,5)
const GUN_OFFSET_Y = Vector2(0,20)

var bullet_scene = preload("Bullet.tscn")
var player_node = null

var rate_of_fire

func _ready():
	pass
	
func fire_weapon(direction):
	var clone0 = bullet_scene.instance()
	var clone1 = bullet_scene.instance()
	var clone2 = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	
	scene_root.add_child(clone0)
	scene_root.add_child(clone1)
	scene_root.add_child(clone2)
	
	clone0.BULLET_DAMAGE = DAMAGE
	clone1.BULLET_DAMAGE = DAMAGE
	clone2.BULLET_DAMAGE = DAMAGE
	
	clone0.KILL_TIMER = 0.2
	clone1.KILL_TIMER = 0.2
	clone2.KILL_TIMER = 0.2

	bullet_origin = get_parent().get_parent().get_parent().position
	
	if direction.x != 0:
		if direction.x > 0:
			bullet_origin.x = get_parent().get_parent().get_parent().position.x + GUN_OFFSET_X.x
			bullet_origin.y = get_parent().get_parent().get_parent().position.y - GUN_OFFSET_X.y
		else:
			bullet_origin.x = get_parent().get_parent().get_parent().position.x - GUN_OFFSET_X.x
			bullet_origin.y = get_parent().get_parent().get_parent().position.y - GUN_OFFSET_X.y
	elif direction.y != 0:
		if direction.y > 0:
			bullet_origin.y = get_parent().get_parent().get_parent().position.y
		else:
			bullet_origin.y = get_parent().get_parent().get_parent().position.y - GUN_OFFSET_Y.y
	
	# First vector is the bullet direction
	# Second vector ???
	# Third vector is the bullet spawn origin
	
	if(direction.y != 0):
		clone0.transform = Transform2D(Vector2(direction.x,direction.y), Vector2(0,0), bullet_origin)
		clone0.scale = Vector2(1, 1)
		clone1.transform = Transform2D(Vector2(0.25,direction.y), Vector2(0,0), bullet_origin)
		clone1.scale = Vector2(1, 1)
		clone2.transform = Transform2D(Vector2(-0.25,direction.y), Vector2(0,0), bullet_origin)
		clone2.scale = Vector2(1, 1)
	else:
		clone0.transform = Transform2D(Vector2(direction.x,direction.y), Vector2(0,0), bullet_origin)
		clone0.scale = Vector2(1, 1)
		clone1.transform = Transform2D(Vector2(direction.x,0.25), Vector2(0,0), bullet_origin)
		clone1.scale = Vector2(1, 1)
		clone2.transform = Transform2D(Vector2(direction.x,-0.25), Vector2(0,0), bullet_origin)
		clone2.scale = Vector2(1, 1)
	ammo_in_weapon -= 1
	
	$Shotgun_Sound.play()
