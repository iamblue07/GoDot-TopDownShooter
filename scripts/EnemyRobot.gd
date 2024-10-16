extends CharacterBody2D

var need_to_close_distance: bool = true
var can_attack_gun: bool = false
var can_attack_melee: bool = false

var speed: int = 800
var health: int = 100

signal RobotShooting(pos, direction)

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	$AnimationPlayer.play("walk")
	duplicate_material($Skeleton2D)

func _physics_process(_delta):
	
	if need_to_close_distance:
		movement()
	else:
		look_at_player()
	if can_attack_melee:
		attack_melee()
	elif can_attack_gun:
		attack_gun()

func hit(damage_taken):
	$HurtAudio.play()
	health -= damage_taken
	if health <= 0:
		queue_free()
	set_shader_parameter($Skeleton2D, 1)
	await get_tree().create_timer(0.1).timeout
	set_shader_parameter($Skeleton2D, 0)

func attack_melee():
	pass

func attack_gun():
	$AnimationPlayer.play("shooting_animation")

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

func set_shader_parameter(node: Node, value):
	if node is Sprite2D and node.material:
		node.material.set_shader_parameter("progress", value)
	for child in node.get_children():
		set_shader_parameter(child, value)

func duplicate_material(node):
	if node is Sprite2D and node.material:
		node.material = node.material.duplicate()
	for child in node.get_children():
		duplicate_material(child)

func _on_distance_closed_area_body_entered(body):
	if body.is_in_group("Player"):
		need_to_close_distance = false


func _on_distance_closed_area_body_exited(body):
	if body.is_in_group("Player"):
		need_to_close_distance = true


func _on_can_attack_gun_area_body_entered(body):
	if body.is_in_group("Player"):
		can_attack_gun = true


func _on_can_attack_gun_area_body_exited(body):
	if body.is_in_group("Player"):
		can_attack_gun = false
		$AnimationPlayer.play("walk")


func _on_can_attack_melee_area_body_entered(body):
	if body.is_in_group("Player"):
		can_attack_melee = true

func _on_can_attack_melee_area_body_exited(body):
	if body.is_in_group("Player"):
		can_attack_melee = false

func gun_attack_anim_method():
	var timerOne = get_tree().create_timer(2)
	var alternate: bool = true
	while timerOne.time_left > 0:
		await get_tree().create_timer(0.1).timeout
		var marker = $AttackMarkers.get_child(alternate)
		alternate = not alternate
		var pos: Vector2 = marker.global_position
		var direction: Vector2 = (Globals.player_pos - position).normalized()
		RobotShooting.emit(pos, direction)


func _on_navigation_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_pos
