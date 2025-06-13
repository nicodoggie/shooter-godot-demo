class_name ItemContainer

extends StaticBody2D

func hit(projectile: Node2D, source: Node2D):
	print($".".name, ' was hit by ', source.name, "'s ", projectile.name)
