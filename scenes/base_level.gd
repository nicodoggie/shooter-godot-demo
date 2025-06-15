class_name BaseLevel

extends Node2D

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene: PackedScene = preload("res://scenes/items/item.tscn")

@export var overworld_zoom: Vector2 = Vector2(0.6, 0.6)
@export var interior_zoom: Vector2 = Vector2(1, 1)

func _ready():
	Globals.current_player = $Player.name
	
	if not Globals.has_player_state($Player.name):
		Globals.save_player_state($Player)
	else:
		Globals.load_player_state($Player)	
	
	$Player/Camera2D.zoom = overworld_zoom
	
	var containers = get_tree().get_nodes_in_group("Container")
	
	for container in containers:
		container.connect("container_opened", _on_container_opened)
		
	var scouts = get_tree().get_nodes_in_group("Scouts")
	
	for scout in scouts:
		print(scout)
		scout.connect("laser_shot", _on_scout_laser_shot)

	$UI.update_ammo_ui($Player)
	$UI.update_grenade_ui($Player)
	$UI.update_health_ui($Player)
	
func shoot_laser(shooter: Node2D) -> void:
	if not shooter.has_method("get_shot_position"):
		return
	
	var marker = shooter.get_shot_position() as Marker2D
	
	if marker and marker.has_node("BloomEffect"):
		var bloom = marker.get_child(0).get_node("BloomEffect") as GPUParticles2D
		bloom.restart()
	
	if marker and marker.has_node("BlasterSmoke"):
		var smoke = marker.get_child(0).get_node("BlasterSmoke") as GPUParticles2D
		smoke.restart()

	var laser = laser_scene.instantiate() as Laser
	laser.connect("laser_hit", _on_hit)
	laser.source = shooter
	laser.position = marker.global_position
	laser.rotation = shooter.global_rotation
	
	$Projectiles.add_child(laser)

func _on_hit(projectile: Node2D, source: Node2D, target: Node2D):
	if target.has_method("hit"):
		target.hit(projectile, source)
	
	projectile.queue_free()

func _on_player_laser_shot(player: Player) -> void:
	print_debug(player.name, " shot a laser at level ", $".".name)
	shoot_laser(player)
	$UI.update_ammo_ui(player)

func _on_player_laser_empty(player: Player) -> void:
	print(player.name, " tried to shoot an empty laser at level ", $".".name)
	
func _on_player_grenade_shot(player: Player, marker: Marker2D) -> void:
	print_debug(player.name, " threw a grenade at level ", $".".name)
	
	var grenade = grenade_scene.instantiate() as Grenade
	grenade.connect("move_stopped", _on_grenade_stopped)
	print_debug(player.name, " exited the gate")
	
	grenade.throw(player)
	grenade.position = marker.global_position
	grenade.linear_velocity = Vector2.from_angle(player.rotation).normalized() * grenade.speed
	
	$UI.update_grenade_ui(player)
	$Projectiles.add_child(grenade)

func _on_player_grenade_empty(player: Player) -> void:
	print_debug(player.name, " ran out of grenades at level ", $".".name)

func _on_grenade_stopped(grenade: Grenade) -> void:
	grenade.explode()

func _on_player_player_hit(player: Player, _source: Node2D = null) -> void:
	print_debug(player.name, " was hit")
	$UI.update_health_ui(player)

func _on_teleport_body_entered(_body: Node2D) -> void:
	TransitionLayer.change_scene("res://scenes/levels/outside.tscn")

func _on_player_item_received(player: Player, item: Item) -> void:
	print(player.name, ' received ', item.amount, ' of ',  item.type)
	$UI.update_ammo_ui(player)
	$UI.update_grenade_ui(player)
	$UI.update_health_ui(player)

func _on_container_opened(pos: Vector2, direction: Vector2):
	var item = item_scene.instantiate() as Item
	item.position = pos
	item.direction = direction
	$Items.add_child(item)

func _on_scout_laser_shot(scout: Scout, player: Player):
	print(scout.name, " shot at ", player.name)
	shoot_laser(scout)
