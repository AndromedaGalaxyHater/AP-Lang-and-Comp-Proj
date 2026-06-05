extends Control


func _process(_delta: float) -> void:
	if Global.won:
		self.visible = true


func _on_return_to_main_menu_pressed() -> void:
	Global.player_health = Global.max_player_health
	var main_menu : PackedScene = load("res://Scenes/World Scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu)
