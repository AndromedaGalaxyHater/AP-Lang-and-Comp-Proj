extends Control

var level : int = 0

func _process(_delta: float) -> void:
	level_up()

func level_up():
	if level < Global.player_level:
		level = Global.player_level
		Global.paused = true
		self.visible = true
		print("level up screen")


func _on_health_increase_pressed() -> void:
	Global.max_player_health += 50
	Global.player_health += 50
	self.visible = false
	print(Global.player_health)
	Global.paused = false

func _on_damage_increase_pressed() -> void:
	Global.damage_mod += 5
	self.visible = false
	Global.paused = false

func _on_speed_increase_pressed() -> void:
	Global.SPEED += 50
	Global.BASE_SPEED += 50
	self.visible = false
	Global.paused = false
