extends CharacterBody2D

var active: bool = false
var player_in_range = false
var speed: int = 200

var damage = 20
var health = 50


func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos

func _physics_process(_delta):
	if active:
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
		var look_angle = direction.angle()
		rotation = look_angle + PI / 2
		move_and_slide()

func _on_notice_area_body_entered(body):
	if body.is_in_group("Player"):
		active = true
		$AnimationPlayer.play("walk")

func _on_notice_area_body_exited(body):
	if body.is_in_group("Player"):
		active = false
		$AnimationPlayer.pause()


func _on_navigation_timer_timeout():
	if active:
		$NavigationAgent2D.target_position = Globals.player_pos


func _on_attack_area_body_entered(_body):
	player_in_range = true
	$AnimationPlayer.play("attack")


func _on_attack_area_body_exited(_body):
	player_in_range = false
	if active:
		$AnimationPlayer.play("walk")
		

func hit(damage_taken):
	$HurtAudio.play()
	health -= damage_taken
	if health <= 0:
		queue_free()

func attack():
	if player_in_range:
		Globals.health -= damage
