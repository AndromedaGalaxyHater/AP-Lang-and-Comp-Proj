extends Control
@onready var anim : AnimationPlayer = %"Controls Shower"

func _ready() -> void:
	if Global.first_steps:
		anim.play("Tooltips")
		Global.first_steps = false
