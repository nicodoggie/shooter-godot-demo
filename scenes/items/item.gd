class_name Item

extends Area2D

var rotation_speed:int = 1
var available_types = ['laser', 'laser', 'laser', 'laser', 'grenade', 'health']
var type: String
var amount: int = 0
var direction: Vector2
var distance: int = randi_range(150, 250)

func update_color(type_name: String) -> void:
	match type_name:
		'laser':
			$Sprite2D.modulate = Color.AQUA
		'grenade':
			$Sprite2D.modulate = Color.GREEN_YELLOW
		'health':
			$Sprite2D.modulate = Color.CRIMSON

func randomize_amount(type_name: String) -> int:
	match type_name:
		"laser":
			return randi_range(10, 50)
		"grenade":
			return randi_range(1, 5)
		"health":
			return randi_range(25, 100)
	return -1

func _ready():
	type = available_types[randi_range(0, len(available_types) - 1)]
	amount = randomize_amount(type)
	update_color(type)
	
	var target_pos = position + direction * distance
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", target_pos, 0.5)
	tween.tween_property(self, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))

func _on_item_received(_item: Item) -> void:
	var typeIndex = randi_range(0, available_types.size() - 1);
	type = available_types[typeIndex]
	update_color(type)

func _process(delta):
	rotation += rotation_speed * delta

func _on_body_entered(body: Node2D) -> void:
	print_debug(body.name, " received item ", type)
	
	var should_free = false
	if body.has_method("add_item"):
		should_free = body.add_item(self)
		
	if should_free:
		queue_free()
