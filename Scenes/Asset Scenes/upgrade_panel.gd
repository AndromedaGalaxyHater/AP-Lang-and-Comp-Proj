extends Control

@export var update_animator : AnimationPlayer


func _on_exit_upgrade_panel_pressed() -> void:
	update_animator.play("LeaveUpgradeScreen")
	self.visible = false


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var ability_dict = Global.ability_list.values()[index]
	# checks for if abilities are being de-selected
	
	if "quick_activated" in ability_dict and Global.quick_dash == true:
		Global.quick_dash = false
	elif "invincible_activated" in ability_dict and Global.invincible_dash == true:
		Global.invincible_dash = false
	elif "fire_activated" in ability_dict and Global.fire_damage == true:
		Global.fire_damage = false
	elif "ice_activated" in ability_dict and Global.ice_damage == true:
		Global.ice_damage = false
	# if the abilities are not selected then
	elif "quick_activated" in ability_dict:
		Global.quick_dash = true
	elif "invincible_activated" in ability_dict:
		Global.invincible_dash = true
	elif "fire_activated" in ability_dict:
		Global.fire_damage = true
		Global.ice_damage = false
	elif "ice_activated" in ability_dict:
		Global.ice_damage = true
		Global.fire_damage = false
	elif "lifesteal" in ability_dict:
		Global.lifesteal = true
	elif "aoe_activated" in ability_dict:
		Global.lifesteal = true
	elif "fireball" in ability_dict:
		Global.fireball = true
	elif "taming_activated" in Global.ability_list.values()[index]:
		Global.enemy_taming = true
		print("taming_activated")
	
