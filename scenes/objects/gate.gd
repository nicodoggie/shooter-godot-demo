extends StaticBody2D

signal body_gate_entered(body: Node2D)

signal body_gate_exited(body: Node2D)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_gate_entered.emit(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	body_gate_exited.emit(body)
