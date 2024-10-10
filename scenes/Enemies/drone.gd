extends CharacterBody2D

var active: bool = false
var max_speed: int = 1000
var speed: int = 0

var health: int = 20

var explosion_active: bool = false
var explosion_damage: int = 30
var speed_multiplier: int = 1

func hit(damage_taken):
	health -= damage_taken
	$HurtAudio.play()
	$Drone.material = $Drone.material.duplicate()
	$Drone.material.set_shader_parameter("progress", 1)
	await get_tree().create_timer(0.1).timeout
	$Drone.material.set_shader_parameter("progress", 0)
	
	if health <= 0:
		speed = 0
		$AnimationPlayer.play("explosion")
		speed_multiplier = 0

func _ready():
	$Explosion.hide()
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos

func _physics_process(delta):
	if active:
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
		var look_angle = direction.angle()
		rotation = look_angle + PI / 2
		var collision = move_and_collide(velocity * delta)
		if collision:
			$AnimationPlayer.play("explosion")
			speed_multiplier = 0
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		explosion_active = false
		for target in targets:
			if target.global_position.distance_to(global_position) < 400 and "hit" in target:
				target.hit(explosion_damage)



func _on_notice_area_body_entered(_body):
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 3)


func explosion_status_update():
	explosion_active = true


func _on_navigation_timer_timeout():
	if active:
		$NavigationAgent2D.target_position = Globals.player_pos
