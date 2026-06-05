extends AnimatedSprite2D

var max_health : int = Global.max_player_health

func _physics_process(_delta: float) -> void:
	match Global.player_health:
		16:
			play("16")
		14:
			play("14")
		12:
			play("12")
		10:
			play("10")
		8:
			play("8")
		6:
			play("6")
		4:
			play("4")
		2:
			play("2")
		0: 
			play("0")
