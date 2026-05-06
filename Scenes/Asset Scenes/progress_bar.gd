extends ProgressBar

var health : int = Global.player_health
var max_health : int = Global.max_player_health

func _physics_process(_delta: float) -> void:
	health = Global.player_health
	self.value = health
	self.max_value = max_health
