extends Control

@export var update_animator : AnimationPlayer
@export var item_list : ItemList

func _ready() -> void:
	reset_upgrades()
	reset_exp()

func _process(_delta: float) -> void:
	unlock_achievements()

func reset_exp():
	Global.player_experience = Global.experience_reset
	Global.player_experience_to_level_up = Global.max_exp_reset

func reset_upgrades():
	Global.quick_dash = false
	Global.invincible_dash = false
	Global.fire_damage = false
	Global.ice_damage = false
	Global.lifesteal = false
	Global.aoe_spell = false
	Global.fireball = false
	Global.enemy_taming = false

func unlock_achievements():
	if Global.quick_achieved:
		item_list.set_item_selectable(0,true)
	if Global.invincible_achieved:
		item_list.set_item_selectable(1,true)
	if Global.fire_achieved:
		item_list.set_item_selectable(2,true)
	if Global.ice_achieved:
		item_list.set_item_selectable(3,true)
	if Global.lifesteal_achieved:
		item_list.set_item_selectable(4,true)
	if Global.aoe_achieved:
		item_list.set_item_selectable(5,true)
	if Global.fireball_achieved:
		item_list.set_item_selectable(6,true)
	if Global.taming_achieved:
		item_list.set_item_selectable(7,true)

func _on_exit_upgrade_panel_pressed() -> void:
	update_animator.play("LeaveUpgradeScreen")

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
	elif "lifesteal_activated" in ability_dict and Global.lifesteal == true:
		Global.lifesteal = false
	elif "aoe_activated" in ability_dict and Global.aoe_spell == true:
		Global.aoe_spell = false
	elif "fireball_activated" in ability_dict and Global.fireball == true:
		Global.fireball = false
	elif "taming_activated" in ability_dict and Global.enemy_taming == true:
		Global.enemy_taming = false
	# if the abilities are not selected then
	elif "quick_activated" in ability_dict and Global.quick_achieved:
		Global.quick_dash = true
	elif "invincible_activated" in ability_dict and Global.invincible_achieved:
		Global.invincible_dash = true
	elif "fire_activated" in ability_dict and Global.fire_achieved:
		Global.fire_damage = true
		wiggog_ywrath_smite_the_andromeda_galaxy_please.deselect(index+1)
		Global.ice_damage = false
	elif "ice_activated" in ability_dict and Global.ice_achieved:
		Global.ice_damage = true
		wiggog_ywrath_smite_the_andromeda_galaxy_please.deselect(index-1)
		Global.fire_damage = false
	elif "lifesteal_activated" in ability_dict and Global.lifesteal_achieved:
		Global.lifesteal = true
	elif "aoe_activated" in ability_dict and Global.aoe_achieved:
		Global.aoe_spell = true
	elif "fireball_activated" in ability_dict and Global.fireball_achieved:
		Global.fireball = true
	elif "taming_activated" in ability_dict and Global.taming_achieved:
		Global.enemy_taming = true
