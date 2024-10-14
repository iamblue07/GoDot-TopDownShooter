extends RootLevel

var level_2_scene_string = "res://scenes/Levels and Locations/PlaytestInterior.tscn"



func _on_arena_on_north_entrance_body_entered(_body):
	print("A player has entered the arena from the north gate!")
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.7)
	TransitionLayer.change_scene(level_2_scene_string)

func _on_arena_on_south_entrance_body_entered(_body):
	print("A player has entered the arena from the south gate!")
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.7)
	TransitionLayer.change_scene(level_2_scene_string)

func _on_house_house_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D,"zoom", Vector2(0.5,0.5), 1)

func _on_house_house_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D,"zoom", Vector2(0.2,0.2), 1)
