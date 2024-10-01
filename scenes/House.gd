extends Area2D

signal house_entered()
signal house_exited()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		house_entered.emit()


func _on_body_exited(body):
	if body.is_in_group("Player"):
		house_exited.emit()
