extends Control

@export var vbox : Control


func _on_resume_pressed() -> void:
	self.visible = false
	Global.paused = false


func _on_options_pressed() -> void:
	var options_menu = %"Options Menu"
	options_menu.visible = true
	vbox.visible = false
	pass

func _on_return_to_main_menu_pressed() -> void:
	var main_menu : PackedScene = load("res://Scenes/World Scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu)
	pass


# is sent when the options menu is left to make the pause menu visible again
func _on_options_menu_leave_options() -> void:
	self.visible = true
	vbox.visible = true
