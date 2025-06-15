class_name Drone

extends CharacterBody2D

@export var is_enemy = true
var speed = 400

func _process(_delta):
	velocity = Vector2.RIGHT * speed
	move_and_slide()
	
func hit(source: Node2D, projectile: Node2D):
	print(name, ' was hit by ', source.name, "'s ", projectile.name)
