class_name Laser
extends Area2D

signal laser_hit(laser: Laser, player: Player, target: Node2D)
#signal laser_timeout(laser: Laser)

@export var speed: int = 1000
var source: Node2D = null

func get_damage():
	return 10

func _ready():
	$DissipationTimer.start()

func _process(delta):
	var direction = Vector2.from_angle(rotation).normalized()
	position += speed * delta * direction

func _on_body_entered(body: Node2D) -> void:
	laser_hit.emit(self, source, body)
	queue_free()

func _on_dissipation_timer_timeout() -> void:
	queue_free()
