extends RootLevel

var hunter = preload("res://scenes/Enemies/hunter.tscn")
var bug = preload("res://scenes/Enemies/bug.tscn")
var drone = preload("res://scenes/Enemies/drone.tscn")
var scout = preload("res://scenes/Enemies/scout.tscn")
var robot = preload("res://scenes/Enemies/AssembledRobot.tscn")

func _on_house_house_entered():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.4, 0.4), 1)


func _on_house_house_exited():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.15, 0.15), 1)


func monsters_spawn(node):
	var marker: Marker2D = $node/MonsterRespawnPoints.get_child(randi() % $node/MonsterRespawnPoints.get_child_count())
	var enemy = hunter.instantiate()
	enemy.position = marker.position
	$Enemies.add_child(enemy)


func _on_car_depo_player_entered():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.35, 0.35), 1)
	$Locations/CarDepo/TileMap/AnimationPlayer.play("Ceiling_fade_effect")
	
func _on_car_depo_player_exited():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.15, 0.15), 1)
	$Locations/CarDepo/TileMap/AnimationPlayer.play("Ceiling_unfade_effect")
	
	


func _on_small_lab_spawn_monster():
	var marker: Marker2D = $"Locations/Small Lab"/MonsterRespawnPoints.get_child(randi() % $"Locations/Small Lab"/MonsterRespawnPoints.get_child_count())
	var enemy
	var odds = randi_range(0,100)
	if odds < 20:
		enemy = hunter.instantiate()
	elif odds < 40:
		enemy = bug.instantiate()
	elif odds < 60:
		enemy = drone.instantiate()
	elif odds < 80:
		enemy = scout.instantiate()
		enemy.connect('laser', _on_scout_laser)
	else:
		enemy = robot.instantiate()
		enemy.connect('RobotShooting', _on_robot_robot_shooting)
	enemy.position = marker.global_position
	$Enemies.add_child(enemy)


func _on_car_depo_spawn_monster():
	var marker: Marker2D = $Locations/CarDepo/MonsterRespawnPoints.get_child(randi() % $Locations/CarDepo/MonsterRespawnPoints.get_child_count())
	var enemy
	var odds = randi_range(0,100)
	if odds < 20:
		enemy = hunter.instantiate()
	elif odds < 40:
		enemy = bug.instantiate()
	elif odds < 60:
		enemy = drone.instantiate()
	elif odds < 80:
		enemy = scout.instantiate()
		enemy.connect('laser', _on_scout_laser)
	else:
		enemy = robot.instantiate()
		enemy.connect('RobotShooting', _on_robot_robot_shooting)
	enemy.position = marker.global_position
	$Enemies.add_child(enemy)
