extends PathFollow2D

var player_near: bool = false

@onready var line1: Line2D = $Turret/RayCast2D/Line2D
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D2

@onready var gunfire1: Sprite2D = $Turret/Gun
@onready var gunfire2: Sprite2D = $Turret/Gun2

func _ready():
	line2.add_point($Turret/RayCast2D2.target_position)

func _process(delta):
	progress_ratio += 0.03 * delta
	if player_near:
		$Turret	.look_at(Globals.player_pos)

func fire():
	Globals.health -= 20
	gunfire1.modulate.a = 1
	gunfire2.modulate.a = 1
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(gunfire1, "modulate:a", 0, 0.2)
	tween.tween_property(gunfire2, "modulate:a", 0, 0.2)
	

func _on_notice_area_body_entered(body):
	if body.is_in_group("Player"):
		player_near = true
		$AnimationPlayer.play("laser_load")

func _on_notice_area_body_exited(body):
	if body.is_in_group("Player"):
		player_near = false
		$AnimationPlayer.pause()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(line1, "width", 0, 1)
		tween.tween_property(line2, "width", 0, 1)
		await tween.finished
		$AnimationPlayer.stop()
