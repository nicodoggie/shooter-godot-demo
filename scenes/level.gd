extends Node2D

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")

@export var overworld_zoom: Vector2 = Vector2(0.6, 0.6)
@export var interior_zoom: Vector2 = Vector2(1, 1)

func _ready():
	$Player/Camera2D.zoom = overworld_zoom

func _on_gate_body_gate_entered(body: Node2D) -> void:
	print_debug(body.name, " entered the gate")
	var tween = create_tween()
	tween.tween_property(body, "init_speed", 0, 0.2)

func _on_gate_body_gate_exited(body: Node2D) -> void:
	print_debug(body.name, " exited the gate")

func _on_player_laser_shot(player: Player, marker: Marker2D) -> void:
	print_debug(player.name, " shot a laser at level ", $".".name)

	var bloom = marker.get_child(0).get_node("BloomEffect") as GPUParticles2D
	var smoke = marker.get_child(0).get_node("BlasterSmoke") as GPUParticles2D
	
	bloom.restart()
	smoke.restart()
	
	var laser = laser_scene.instantiate() as Laser
	laser.connect(laser.laser_hit.get_name(), _on_player_laser_hit)
	laser.player = player
	laser.position = marker.global_position
	laser.rotation = player.global_rotation

	$Projectiles.add_child(laser)

func _on_player_laser_empty(player: Player) -> void:
	print(player.name, " tried to shoot an empty laser at level ", $".".name)

func _on_player_laser_hit(laser: Laser, player: Player, target: Node2D) -> void:
	print("Player", player.name, "'s laser hit ", target.name)

	if target.has_method("hit"):
		target.hit(player, laser)
	
	laser.queue_free()
	

func _on_player_grenade_shot(player: Player, marker: Marker2D) -> void:
	print_debug(player.name, " threw a grenade at level ", $".".name)
	
	var grenade = grenade_scene.instantiate() as Grenade
	grenade.connect("move_stopped", _on_grenade_stopped)
	print_debug(player.name, " exited the gate")
	
	grenade.throw()
	grenade.position = marker.global_position
	grenade.linear_velocity = Vector2.from_angle(player.global_rotation).normalized() * grenade.speed

	$Projectiles.add_child(grenade)

func _on_player_grenade_empty(player: Player) -> void:
	print_debug(player.name, " ran out of grenades at level ", $".".name)

func _on_grenade_stopped(grenade: Grenade) -> void:
	print_debug(grenade.name, ' grenade stopped.')
	grenade.explode()


func _on_house_player_entered(house: Area2D, player: Player) -> void:
	print_debug(player.name, " entered the ", house.name)
	var tween = get_tree().create_tween()
	tween.tween_property(player.get_node("Camera2D"), "zoom", interior_zoom, 1).set_trans(Tween.TRANS_QUAD)


func _on_house_player_exited(house: Area2D, player: Player) -> void:
	print_debug(player.name, " exited the ", house.name)
	var tween = get_tree().create_tween()
	tween.tween_property(player.get_node("Camera2D"), "zoom", overworld_zoom, 1).set_trans(Tween.TRANS_QUAD)
