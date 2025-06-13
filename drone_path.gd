extends Node2D

func _ready():
	$Drone.position = Vector2(100, 100)


func _process(delta):
	if($Drone.position.x > 1000):
		$Drone.position.x = 0
