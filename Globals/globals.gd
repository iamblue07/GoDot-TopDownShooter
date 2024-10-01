extends Node

signal stat_change

var player_hit_sound: AudioStreamPlayer2D

var laser_amount = 100:
	get:
		return laser_amount
	set(value):
		laser_amount = value
		stat_change.emit()
		
var grenade_amount = 20:
	get:
		return grenade_amount
	set(value):
		grenade_amount = value
		stat_change.emit()
		
var health = 60:
	get:
		return health
	set(value):
		if value < health:
			player_hit_sound.play()
		health = value
		stat_change.emit()

var player_pos: Vector2

func _ready():
	player_hit_sound = AudioStreamPlayer2D.new()
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")
	player_hit_sound.volume_db = -20
	add_child(player_hit_sound)
