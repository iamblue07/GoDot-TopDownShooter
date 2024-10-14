extends Node2D

signal spawn_monster()


func _on_monster_respawn_timer_timeout():
	spawn_monster.emit()
