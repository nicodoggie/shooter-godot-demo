class_name Grenade

extends RigidBody2D

signal move_stopped(grenade: Grenade)
 
@export var speed: int = 700
var thrown: bool = false
var last_position = Vector2.ZERO

func _ready():
	thrown = false

func explode():
	print('Exploded')
	$Explosion.visible = true
	$ExplosionPlayer.play("Explosion")
	
func throw():
	print('Thrown')
	thrown = true
	$TimerLight.visible = true
	$LightPlayer.play("TimerLight")

func _process(_delta):
	if floor(position * 10) == floor(last_position * 10):
		move_stopped.emit($".")
	last_position = position
