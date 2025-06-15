class_name Scout

extends CharacterBody2D

signal laser_shot(scout: Scout, target: Player)

var target_nearby: bool = false
var target: Player
var can_laser: bool = true
var gun_switch: bool = false
var health: int = 50

func get_shot_position():
	var marker = $LaserStartPosition.get_child(int(gun_switch))
	gun_switch = not gun_switch
	return marker
	

func _process(_delta):
	look_at(Globals.current_player_pos)
	
	if target_nearby and target:
		if can_laser:
			
			laser_shot.emit($".", target)
			
			can_laser = false
			$LaserCooldown.start()

func _on_attack_range_body_entered(body: Node2D) -> void:
	print(body.name, " entered ", $".".name, "'s range.")
	target = body
	target_nearby = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	print(body.name, " exited ", $".".name, "'s range.")
	target_nearby = false

func hit(projectile: Node2D, source: Node2D):
	print("A ", projectile.name, " from ", source.name, " hit ", self.name, ".")
	# Add explosion
	if projectile.has_method('get_damage'):
		print(health)
		health -= projectile.get_damage()
		$ProgressBar.value = health
	
	if health <= 0:
		queue_free()

func _on_laser_cooldown_timeout() -> void:
	can_laser = true
