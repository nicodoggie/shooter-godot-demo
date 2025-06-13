class_name Player

extends CharacterBody2D

signal laser_shot(player: Player, marker: Marker2D)
signal laser_hit(player: Player, body: Node2D)
signal laser_empty(player: Player)
signal grenade_shot(player: Player, marker: Marker2D)
signal grenade_empty(player: Player)

var can_laser: bool = true
var can_grenade: bool = true

@export var ammo = 50
@export var grenades = 5
@export var init_speed = 500

var angle = -PI / 2

func _ready():
	print("player loaded")
	
func _process(_delta):
	var speed = init_speed
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("run"):
		speed = 3 * init_speed
	
	angle = atan2(direction.y, direction.x)
	velocity = direction * speed
	
	move_and_slide()
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary action") and can_laser:
		can_laser = false
		$LaserTimer.start()
		var laser_positions = $LaserStartPosition.get_children()
		
		if ammo > 0:
			ammo -= 1
			var random_node = randi_range(0, laser_positions.size() - 1)
			var selected_marker = laser_positions[random_node]
			
			laser_shot.emit($".", selected_marker)
			print("pew ", ammo)
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
			print("boooom ", grenades)
		else:
			grenade_empty.emit($".")
			print("out of grenades")

func _on_laser_timer_timeout() -> void:
	can_laser = true

func _on_grenade_timer_timeout() -> void:
	can_grenade = true
