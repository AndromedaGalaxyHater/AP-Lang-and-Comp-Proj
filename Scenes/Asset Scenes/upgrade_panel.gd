extends Control

@export var update_animator : AnimationPlayer

func _on_exit_upgrade_panel_pressed() -> void:
	update_animator.play("LeaveUpgradeScreen")
