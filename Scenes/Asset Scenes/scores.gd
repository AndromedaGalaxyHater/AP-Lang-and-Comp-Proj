extends Control
@onready var label : Label = %"Score Text"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = "Score: " + str(Global.points) +"
	High Score: " + str(Global.max_points)
	if Global.paused:
		visible = false
	else:
		visible = true
