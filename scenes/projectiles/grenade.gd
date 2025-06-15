class_name Grenade

extends RigidBody2D

signal move_stopped(grenade: Grenade)
 
@export var speed: int = 700
var thrown: bool = false
var thrown_by: Node2D
var last_position = Vector2.ZERO
var explosion_active: bool = false
var blast_radius: float = 400
var can_damage: bool = true

func _ready():
	thrown = false
	
func _process(_delta):
	if floor(position * 10) == floor(last_position * 10):
		move_stopped.emit($".")
	last_position = position
	
	if explosion_active:
		var containers = get_tree().get_nodes_in_group("Container")
		var entities = get_tree().get_nodes_in_group("Entity")

		var targets = entities + containers
		for target in targets:
			var distance = global_position.distance_to(target.global_position)
			if distance <= blast_radius:
				if can_damage and explosion_active:
					can_damage = false
					$DamageTimeout.start()
					if target.has_method("hit"):
						target.hit(self, thrown_by)
						
					
	
func get_damage():
	return 5

func explode():
	$Explosion.visible = true
	$ExplosionPlayer.play("Explosion")
	explosion_active = true
	await $ExplosionPlayer.animation_finished
	explosion_active = false
	
func throw(entity: Node2D):
	print('Thrown')
	thrown = true
	thrown_by = entity
	$TimerLight.visible = true
	$LightPlayer.play("TimerLight")


func _on_damage_timeout_timeout() -> void:
	can_damage = true
