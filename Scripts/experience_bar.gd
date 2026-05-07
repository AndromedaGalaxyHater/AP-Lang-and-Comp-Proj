extends ProgressBar


func _process(_delta: float) -> void:
	var experience : int = Global.player_experience
	var max_exp : int = Global.player_experience_to_level_up
	
	self.value = experience
	self.max_value = max_exp
	
	if experience == max_exp:
		Global.player_level += 1
		Global.player_experience = 0
		Global.player_experience_to_level_up *= 2
		print("leveled up to level ", Global.player_level)
