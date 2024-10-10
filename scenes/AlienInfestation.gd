extends RootLevel

var hunter = preload("res://scenes/Enemies/hunter.tscn")
var count = 4

func _on_house_house_entered():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.4, 0.4), 1)


func _on_house_house_exited():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.15, 0.15), 1)




func _on_monsters_respawn_timer_timeout():
	if count < 4:
		count += 1
		var marker: Marker2D = $MonsterRespawnPoints.get_child(randi() % $MonsterRespawnPoints.get_child_count())
		var enemy = hunter.instantiate()
		enemy.position = marker.position
		$Enemies.add_child(enemy)
		$Timers/MonstersRespawnTimer.start


func _on_car_depo_player_entered():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.35, 0.35), 1)
	$Decorations/CarDepo/TileMap/AnimationPlayer.play("Ceiling_fade_effect")
func _on_car_depo_player_exited():
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.15, 0.15), 1)
	$Decorations/CarDepo/TileMap/AnimationPlayer.play("Ceiling_unfade_effect")
	
	
