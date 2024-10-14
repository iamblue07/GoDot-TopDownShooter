extends Node2D
class_name RootLevel

var laser_scene = preload("res://scenes/Weapons/laser.tscn")
var grenade_scene = preload("res://scenes/Weapons/grenade.tscn")
var item_scene = preload("res://Items/item.tscn")
var GRENADE_SPEED = 175

func _ready():
	for container in get_tree().get_nodes_in_group('Container'):
		container.connect("open", _on_container_opened)
	
	for scout in get_tree().get_nodes_in_group("Scouts"):
		scout.connect('laser', _on_scout_laser)
	
func _on_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	item.scale = Vector2(0.3, 0.3)
	$Items.call_deferred('add_child', item)
	

func _on_player_laser(pos, direction):
	create_laser(pos,direction)

	
func _on_player_grenade(pos, direction):
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.GRENADE_SPEED
	$Projectiles.add_child(grenade)


func _on_scout_laser(pos, direction):
	create_laser(pos, direction)


func create_laser(pos, direction):
	var laser = laser_scene.instantiate() as Area2D
	laser.position = pos
	laser.direction = direction
	laser.rotation = direction.angle()
	$Projectiles.add_child(laser)
