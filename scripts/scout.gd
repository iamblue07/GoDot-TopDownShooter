extends CharacterBody2D

var player_nearby: bool = false
var can_laser: bool = true
var alternate: bool = true

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
		



func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var markers = $LaserSpawnPositions.get_child(alternate)
			var pos: Vector2 = markers.global_position
			alternate = not alternate
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$LaserCooldown.start()

func _on_attack_area_body_entered(_body):
	player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_laser_cooldown_timeout():
	can_laser = true
