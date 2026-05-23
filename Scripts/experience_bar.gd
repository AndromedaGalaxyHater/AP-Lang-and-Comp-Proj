extends ProgressBar

@onready var tween_timer = %"Tween Timer"
var extra_exp : int = 0
var experience : int = Global.player_experience
var max_exp : int = Global.player_experience_to_level_up

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	experience = Global.player_experience
	max_exp = Global.player_experience_to_level_up
	level_up()
	
	if tween_timer.is_stopped():
		animate_change(Global.player_experience)
	

func animate_change(target_value, duration : float = 0.5):
	var tween = create_tween()
	tween.tween_property(self, "value", target_value, duration)
	tween_timer.start()
	
	
func level_up():
	if experience >= max_exp:
		extra_exp = 0
		if experience > max_exp:
			extra_exp = experience - max_exp
		Global.player_level += 1
		Global.player_experience = 0 + extra_exp
		Global.player_experience_to_level_up *= 2
		self.max_value *= 2
