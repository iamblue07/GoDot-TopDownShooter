extends StaticBody2D

signal on_south_entrance_body_entered(body)
signal on_north_entrance_body_entered(body)

func _on_area_2d_south_arena_entrace_body_entered(body):
	on_south_entrance_body_entered.emit(body)

func _on_area_2d_north_arena_entrace_2_body_entered(body):
	on_north_entrance_body_entered.emit(body)
