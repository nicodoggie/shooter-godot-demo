class_name ItemContainer

extends StaticBody2D

signal container_opened(pos: Vector2, direction: Vector2)

@onready var current_direction = Vector2.DOWN.rotated(global_rotation).normalized()

var opened = false
var max_items: int = 1

func get_random_spawn_marker():
	var index = randi_range(0, $SpawnPositions.get_child_count() - 1)
	return $SpawnPositions.get_child(index)

func hit(projectile: Node2D, source: Node2D):
	print($".".name, ' was hit by ', source.name, "'s ", projectile.name, current_direction)
	if not opened:
		$LidSprite.hide()
		opened = true
		
		for i in range(1, max_items + 1):
			print(current_direction)
			var marker = get_random_spawn_marker()
			container_opened.emit(marker.global_position, current_direction)
	
