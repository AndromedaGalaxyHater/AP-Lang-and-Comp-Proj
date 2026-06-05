extends Control


func _process(_delta: float) -> void:
	if Global.lost:
		self.visible = true
	

func _on_return_to_main_menu_pressed() -> void:
	pass # Replace with function body.
