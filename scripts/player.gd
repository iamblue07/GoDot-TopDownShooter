extends CharacterBody2D

var max_speed: int = 1500
@export var speed: int = max_speed

var can_laser = true
var can_grenade = true

signal laser(pos, direction)
signal grenade(pos, direction)

func hit(damage):
	Globals.health -= damage
	print('Player was hit')

func _ready():
	pass

func _process(_delta):
	Globals.player_pos = global_position
	
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = speed * direction
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	if Input.is_action_pressed("Laser") && can_laser == true && Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser_marker = laser_markers[randi() % laser_markers.size()]
		
		laser.emit(selected_laser_marker.global_position, player_direction)
		$GPUParticles2D.emitting = true
		can_laser = false
		$TimerLaser.start()
		
	if Input.is_action_pressed("Grenade") && can_grenade == true && Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		var grenade_markers = $GrenadeStartPositions.get_children()
		var selected_grenade_marker = grenade_markers[randi() % grenade_markers.size()]
		
		grenade.emit(selected_grenade_marker.global_position, player_direction)
		can_grenade = false
		$TimerGrenade.start()
	

func _on_timer_main_action_timeout():
	can_laser = true


func _on_timer_secondary_action_timeout():
	can_grenade = true	
