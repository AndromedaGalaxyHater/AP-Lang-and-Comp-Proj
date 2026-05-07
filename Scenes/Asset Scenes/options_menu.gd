extends Control

signal leave_options()

func _on_leave_menu_pressed() -> void:
	self.visible = false
	Global.paused = false
	leave_options.emit()
