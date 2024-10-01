extends CharacterBody2D

var active: bool = false
var speed: int = 300
var player_near: bool = false

var damage_given = 10
var health = 20

func _process(delta):
	var direction = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	if active:
		move_and_slide()
		look_at(Globals.player_pos)

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

func _on_attack_area_body_entered(_body):
	player_near = true
	$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(_body):
	player_near = false


func _on_notice_area_body_entered(_body):
	active = true
	$AnimatedSprite2D.play("walk")


func _on_notice_area_body_exited(_body):
	active = false
	$AnimatedSprite2D.stop()


func _on_animated_sprite_2d_animation_finished():
	if player_near:
		Globals.health -= damage_given
		$Timers/AttackTimer.start()

func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("attack")
