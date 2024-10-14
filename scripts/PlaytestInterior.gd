extends RootLevel

var level_1_scene_string : String = "res://scenes/Levels and Locations/PlaytestExterior.tscn"

func _on_south_entrance_body_entered(_body):
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.7)
	TransitionLayer.change_scene(level_1_scene_string)


func _on_north_entrance_body_entered(_body):
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.7)
	TransitionLayer.change_scene(level_1_scene_string)
