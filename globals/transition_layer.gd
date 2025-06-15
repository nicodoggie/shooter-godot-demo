extends CanvasLayer

signal scene_changing
signal scene_changed

func change_scene(target: String):
	scene_changing.emit()
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade_to_black")
	
	scene_changed.emit()
