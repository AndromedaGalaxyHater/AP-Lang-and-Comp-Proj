extends Control

var level : int = 0

func _process(_delta: float) -> void:
	level_up()

func level_up():
	if level < Global.player_level:
		level = Global.player_level
		self.visible = true
		print("level up screen")


func _on_health_increase_pressed() -> void:
	Global.max_player_health += 50
	Global.player_health += 50
	self.visible = false
	print(Global.player_health)

func _on_damage_increase_pressed() -> void:
	Global.sword_damage *= 2
	self.visible = false

func _on_speed_increase_pressed() -> void:
	Global.SPEED += 50
	Global.BASE_SPEED += 50
	self.visible = false
