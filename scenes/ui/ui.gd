extends CanvasLayer

@onready var ammo_label: Label = $AmmoCounter/VBoxContainer/Label
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
@onready var ammo_icon: TextureRect = $AmmoCounter/VBoxContainer/TextureRect
@onready var grenade_icon: TextureRect = $GrenadeCounter/VBoxContainer/TextureRect
@onready var health_bar: TextureProgressBar = $MarginContainer/HealthBar

var green: Color = Color("6bbfa3")
var red: Color = Color(.9, 0, 0, 1)

func _ready():
	print("UI ready", Globals.current_player)

func update_color(value: int, label: Label, icon: TextureRect) -> void:
	if value > 0:
		label.modulate = green
		icon.modulate = green
	else:
		label.modulate = red
		icon.modulate = red

func update_ammo_ui(player: Player):
	ammo_label.text = str(player.ammo, "/", player.max_ammo)
	update_color(player.ammo, ammo_label, ammo_icon)
	
func update_grenade_ui(player: Player):
	grenade_label.text = str(player.grenades, "/", player.max_grenades)
	update_color(player.grenades, grenade_label, grenade_icon)
	
func update_health_ui(player: Player):
	health_bar.max_value = player.max_health
	health_bar.value = player.health
