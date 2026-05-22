extends Control

@onready var upgrade_anim : AnimationPlayer = %UpgradeAnimation
@onready var main_panel = %Main_Panel
@onready var options_menu = %"Options Menu"
@onready var upgrade_panel = %UpgradePanel


# changes scene once pressed and maybe brings to character and world chooser
func _on_play_pressed() -> void:
	Global.paused = false
	var level_one = load("res://Scenes/World Scenes/World_Scene.tscn")
	get_tree().change_scene_to_packed(level_one)


func _on_upgrades_pressed() -> void:
	upgrade_anim.play("UpgradeAnimation")
	upgrade_panel.visible = true


func _on_options_pressed() -> void:
	options_menu.visible = true
	main_panel.visible = false


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_menu_leave_options() -> void:
	main_panel.visible = true
	options_menu.visible = false
