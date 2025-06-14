extends CanvasLayer

@onready var ammo_label: Label = $AmmoCounter/VBoxContainer/Label
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
@onready var ammo_icon: TextureRect = $AmmoCounter/VBoxContainer/TextureRect
@onready var grenade_icon: TextureRect = $GrenadeCounter/VBoxContainer/TextureRect
@onready var health_bar: TextureProgressBar = $MarginContainer/HealthBar	

var green: Color = Color("6bbfa3")
var red: Color = Color(.9, 0, 0, 1)
		
func _ready():
	update_ammo_ui()
	update_grenade_ui()
	update_health_ui()

func update_color(value: int, label: Label, icon: TextureRect) -> void:
	if value > 0:
		label.modulate = green
		icon.modulate = green
	else:
		label.modulate = red
		icon.modulate = red

func update_ammo_ui():
	var ammo: int = Globals.player_ammo
	ammo_label.text = str(ammo, "/", Globals.player_max_ammo)
	update_color(ammo, ammo_label, ammo_icon)
	
func update_grenade_ui():
	var grenades = Globals.player_grenades
	grenade_label.text = str(grenades, "/", Globals.player_max_grenades)
	update_color(grenades, grenade_label, grenade_icon)
	
func update_health_ui():
	health_bar.max_value = Globals.player_max_health
	health_bar.value = Globals.player_health
