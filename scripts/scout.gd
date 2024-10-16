extends CharacterBody2D

var player_attack: bool = false
var close_distance: bool = true
var can_laser: bool = true
var alternate: bool = true

var speed = 800
var health: int = 30

signal laser(pos, direction)

func hit(damage):
	health -= damage
	$HurtAudio.play()
	$Sprite2D.material = $Sprite2D.material.duplicate()
	$Sprite2D.material.set_shader_parameter("progress", 1)
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.material.set_shader_parameter("progress", 0)
	
	if health <= 0:
		queue_free()
		
func look_at_player():
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	var look_angle = direction.angle()
	rotation = look_angle + PI / 2

func movement():
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	var look_angle = direction.angle()
	rotation = look_angle + PI / 2
	velocity = direction * speed
	move_and_slide()

func attack():
	var markers = $LaserSpawnPositions.get_child(alternate)
	var pos: Vector2 = markers.global_position
	alternate = not alternate
	var direction: Vector2 = (Globals.player_pos - position).normalized()
	print("Laser emitted")
	laser.emit(pos, direction)
	can_laser = false
	$Timers/LaserCooldown.start()

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos

func _physics_process(_delta):
	
	if close_distance:
		movement()
	else:
		look_at_player()
	if can_laser && player_attack:
		attack()

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player_attack = true


func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		player_attack = false


func _on_laser_cooldown_timeout():
	can_laser = true


func _on_distance_area_body_entered(body):
	if body.is_in_group("Player"):
		close_distance = false


func _on_distance_area_body_exited(body):
	if body.is_in_group("Player"):
		close_distance = true


func _on_navigation_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_pos
