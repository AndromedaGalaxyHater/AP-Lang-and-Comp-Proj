extends Node2D

@export var slime : PackedScene 


func _on_respawn_timer_timeout() -> void:
	var new_slime = slime.instantiate()
	add_child(new_slime)
