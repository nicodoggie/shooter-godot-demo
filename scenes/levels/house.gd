extends Area2D

signal player_entered(house: Area2D, player: Player)
signal player_exited(house: Area2D, player: Player)

func _on_body_entered(body: Node2D) -> void:
	player_entered.emit($".", body)	

func _on_body_exited(body: Node2D) -> void:
	player_exited.emit($".", body)
