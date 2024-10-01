extends Area2D

var speed = 5000
var direction: Vector2
var laser_damage = 10

func _ready():
	$Remove_timer.start()
	$AudioStreamPlayer2D.play()

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	queue_free()
	if "hit" in body:
		body.hit(laser_damage)


func _on_remove_timer_timeout():
	queue_free()
