extends Position2D

# Variables for storing how much ammo is in the weapon, how much spare ammo this weapon has
# and how much ammo is in a full weapon/magazine.
var ammo_in_weapon = 10
var spare_ammo = 20
const AMMO_IN_MAG = 10

const DAMAGE = 15

# Can this weapon reload?
const CAN_RELOAD = true
# Can this weapon be refilled
const CAN_REFILL = true


var bullet_scene = preload("Bullet.tscn")

# The player script. This is so we can easily access the animation player
# and other variables.
var player_node = null

func _ready():
	# We are going to assume the player will pass themselves in.
	# While we can have cases where the player does not pass themselves in,
	# having a complicated get_node call does not look pretty and it (relatively) safe to assume
	# player_node will be passed in.
	pass
	

func fire_weapon(direction):
	var clone = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)
	
	clone.transform = Transform2D(Vector2(direction.x,direction.y), Vector2(0,0), position)
	clone.scale = Vector2(1, 1)
	clone.BULLET_DAMAGE = DAMAGE
	ammo_in_weapon -= 1
	
	# Play the gun sound
	$Shotgun_Sound.play()
