extends Node2D

signal player_entered()
signal player_exited()

func _on_interior_body_entered(body):
	if body.is_in_group("Player"):
		player_entered.emit()
	


func _on_interior_body_exited(body):
	if body.is_in_group("Player"):
		player_exited.emit()


func hide_ceiling_decorations():
	$TileMap.set_layer_enabled(4, false)
	for child in $CeilingDecorations.get_children():
		child.visible = false


func show_lights():
	for child in $Lights.get_children():
		child.visible = true

func show_ceiling_decorations():
	$TileMap.set_layer_enabled(4, true)
	for child in $CeilingDecorations.get_children():
		child.visible = true


func hide_lights():
	for child in $Lights.get_children():
		child.visible = false

