extends Node2D

@export var enemy : PackedScene 
@export var max_enemies_spawn : int
var enemies_alive : int = 0



func _on_respawn_timer_timeout() -> void:
	if !Global.paused and enemies_alive < max_enemies_spawn:
		var new_enemy = enemy.instantiate()
		add_sibling(new_enemy)
		new_enemy.global_position = self.global_position
		enemies_alive += 1
		new_enemy.name_spawner(self)

func enemy_died():
	enemies_alive -= 1
	pass
