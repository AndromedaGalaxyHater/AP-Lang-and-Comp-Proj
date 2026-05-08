extends Control

@export var update_animator : AnimationPlayer


func _on_exit_upgrade_panel_pressed() -> void:
	update_animator.play("LeaveUpgradeScreen")
	self.visible = false


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var ability_dict = Global.ability_list.values()[index]
	var wiggog_ywrath_smite_the_andromeda_galaxy_please = %ItemList
	# checks for if abilities are being de-selected
	if "quick_activated" in ability_dict and Global.quick_dash == true:
		Global.quick_dash = false
	elif "invincible_activated" in ability_dict and Global.invincible_dash == true:
		Global.invincible_dash = false
	elif "fire_activated" in ability_dict and Global.fire_damage == true:
		Global.fire_damage = false
	elif "ice_activated" in ability_dict and Global.ice_damage == true:
		Global.ice_damage = false
	elif "lifesteal" in ability_dict and Global.lifesteal == true:
		Global.lifesteal = false
	elif "aoe_activated" in ability_dict and Global.aoe_spell == true:
		Global.aoe_spell = false
	elif "fireball" in ability_dict and Global.fireball == true:
		Global.fireball = false
	elif "taming_activated" in ability_dict and Global.enemy_taming == true:
		Global.enemy_taming = false
	# if the abilities are not selected then
	elif "quick_activated" in ability_dict:
		print("selected")
		Global.quick_dash = true
	elif "invincible_activated" in ability_dict:
		Global.invincible_dash = true
	elif "fire_activated" in ability_dict:
		Global.fire_damage = true
		print("Fire on Ice off")
		wiggog_ywrath_smite_the_andromeda_galaxy_please.deselect(index+1)
		Global.ice_damage = false
	elif "ice_activated" in ability_dict:
		Global.ice_damage = true
		print("Ice on Fire off")
		wiggog_ywrath_smite_the_andromeda_galaxy_please.deselect(index-1)
		Global.fire_damage = false
	elif "lifesteal" in ability_dict:
		Global.lifesteal = true
	elif "aoe_activated" in ability_dict:
		Global.lifesteal = true
	elif "fireball" in ability_dict:
		Global.fireball = true
	elif "taming_activated" in ability_dict:
		Global.enemy_taming = true
		print("taming_activated")
	
