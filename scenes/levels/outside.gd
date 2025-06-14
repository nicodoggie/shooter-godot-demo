class_name OutsideLevel

extends BaseLevel

func _on_gate_body_gate_entered(body: Node2D) -> void:
	print_debug(body.name, " entered the gate")
	var tween = create_tween()
	tween.tween_property(body, "init_speed", 0, 0.2)
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")

func _on_gate_body_gate_exited(body: Node2D) -> void:
	print_debug(body.name, " exited the gate")

func _on_house_player_entered(house: Area2D, player: Variant) -> void:
	print_debug(player.name, " entered the ", house.name)

	if player.has_node("Camera2D"):
		var tween = get_tree().create_tween()
		tween.tween_property(player.get_node("Camera2D"), "zoom", interior_zoom, 1).set_trans(Tween.TRANS_QUAD)

func _on_house_player_exited(house: Area2D, player: Player) -> void:
	print_debug(player.name, " exited the ", house.name)
	var tween = get_tree().create_tween()
	tween.tween_property(player.get_node("Camera2D"), "zoom", overworld_zoom, 1).set_trans(Tween.TRANS_QUAD)
