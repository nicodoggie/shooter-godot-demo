class_name Player

extends CharacterBody2D

signal player_hit(player: Player, source: Node2D)
signal player_destroyed(player: Player)
signal laser_shot(player: Player, marker: Marker2D)
#signal laser_hit(player: Player, body: Node2D)
signal laser_empty(player: Player)
signal grenade_shot(player: Player, marker: Marker2D)
signal grenade_empty(player: Player)

signal item_received(player: Player, item: Item)
# signal item_ignored(player: Player, item: Item)

var can_laser: bool = true
var can_grenade: bool = true

# Stats
@export var max_health = 100
@export var health = 100
@export var ammo = 50
@export var max_ammo = 50
@export var grenades = 5
@export var max_grenades = 5

@export var init_speed = 500

var angle = -PI / 2

func _ready():
	TransitionLayer.connect("scene_changing", _on_transition_scene_changing)
	TransitionLayer.connect("scene_changed", _on_transition_scene_changed)

func hit(projectile: Node2D, source: Node2D = null):
	if projectile.has_method("get_damage"):
		health -= projectile.get_damage()
		print(health)
		if health < 0:
			health = 0
		if health == 0:
			player_destroyed.emit(self)
			hide()

	print('Player hit by ', projectile.name)
	player_hit.emit(self, source)
	
func get_shot_position():
	var laser_positions = $LaserStartPosition.get_children()
	var random_node = randi_range(0, laser_positions.size() - 1)
	return laser_positions[random_node]
	
func _process(_delta):
	var speed = init_speed
	var direction = Input.get_vector("left", "right", "up", "down")
	Globals.current_player_pos = global_position
	
	if Input.is_action_pressed("run"):
		speed = 3 * init_speed
	
	angle = atan2(direction.y, direction.x)
	velocity = direction * speed
	
	move_and_slide()
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary action") and can_laser:
		can_laser = false
		$LaserTimer.start()
		
		if ammo > 0:
			ammo -= 1
			
			laser_shot.emit($".")
		else:
			laser_empty.emit($".")
			print("out of ammo")
	if Input.is_action_pressed("secondary action") and can_grenade:
		can_grenade = false
		$GrenadeTimer.start()
		
		var grenade_positions = $GrenadeStartPosition.get_children()
		
		if grenades > 0:
			grenades -= 1
			var random_node = randi_range(0, grenade_positions.size() - 1)
			var selected_marker = grenade_positions[random_node]
			
			grenade_shot.emit($".", selected_marker)
		else:
			grenade_empty.emit($".")
			print("out of grenades")
			
func add_item(item: Item):
	var should_receive = true
	match item.type:
		'laser':
			if ammo == max_ammo:
				should_receive = false
			elif item.amount + ammo > max_ammo:
				ammo = max_ammo
			else:
				ammo += item.amount 
		'grenade':
			if grenades == max_grenades:
				should_receive = false
			elif item.amount + grenades > max_grenades:
				grenades = max_grenades
			else:
				grenades += item.amount
		'health':
			health = max_health
	item_received.emit($".", item)
	return should_receive

func _on_laser_timer_timeout() -> void:
	can_laser = true

func _on_grenade_timer_timeout() -> void:
	can_grenade = true

func _on_transition_scene_changing():
	Globals.save_player_state($".")

func _on_transition_scene_changed():
	Globals.load_player_state($".")
