extends CharacterBody2D

var speed: int = 1000
var player_near: bool = false

var damage_given = 10
var health = 20

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	$AnimatedSprite2D.play("walk")

func _physics_process(_delta):
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	velocity = direction * speed
	var look_angle = direction.angle()
	rotation = look_angle + PI / 2
	move_and_slide()

func hit(damage_taken):
	health -= damage_taken
	$HurtAudio.play()
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)
	$Particles/HitParticles.emitting = true
	
	if health <= 0:
		queue_free()

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player_near = true
		$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		player_near = false
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("walk")


func _on_animated_sprite_2d_animation_finished():
	if player_near:
		Globals.health -= damage_given
		$Timers/AttackTimer.start()

func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("attack")


func _on_navigation_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_pos
