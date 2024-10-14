extends CharacterBody2D

var player_in_range = false
var speed: int = 1200

var damage = 20
var health = 50


func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	$AnimationPlayer.play("walk")
	duplicate_material($Skeleton2D)
	
func _physics_process(_delta):
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	velocity = direction * speed
	var look_angle = direction.angle()
	rotation = look_angle + PI / 2
	move_and_slide()

func _on_navigation_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_pos


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		$AnimationPlayer.play("attack")


func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		$AnimationPlayer.play("walk")

func hit(damage_taken):
	$HurtAudio.play()
	health -= damage_taken
	if health <= 0:
		queue_free()
	set_shader_parameter($Skeleton2D, 1)
	await get_tree().create_timer(0.1).timeout
	set_shader_parameter($Skeleton2D, 0)

func attack():
	if player_in_range:
		Globals.health -= damage

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

