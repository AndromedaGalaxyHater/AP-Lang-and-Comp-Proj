extends Panel

@onready var upgrade_text : Label = %"Upgrade Achieved Text"
@onready var upgrade_animator : AnimationPlayer = $"Upgrade Animations"

var quick_dash_on : bool = false
var invincible_dash_on : bool = false
var fire_damage_on : bool = false
var ice_damage_on : bool = false
var lifesteal_on : bool = false
var aoe_on : bool = false
var fireball_on : bool = false
var taming_on : bool = false

func _process(_delta: float) -> void:
	check_ability_updates()
	

func check_ability_updates():
	if Global.quick_achieved and quick_dash_on == false and upgrade_animator.is_playing() == false:
		quick_dash_on = true
		upgrade_text.text = "Quick Dash"
		upgrade_animator.play("Upgrade Got")
	elif Global.invincible_achieved and invincible_dash_on == false and upgrade_animator.is_playing() == false:
		invincible_dash_on = true
		upgrade_text.text = "Invincible Dash"
		upgrade_animator.play("Upgrade Got")
	elif Global.fire_achieved and fire_damage_on == false and upgrade_animator.is_playing() == false:
		fire_damage_on = true
		upgrade_text.text = "Fire Damage"
		upgrade_animator.play("Upgrade Got")
	elif Global.ice_achieved and ice_damage_on == false and upgrade_animator.is_playing() == false:
		ice_damage_on = true
		upgrade_text.text = "Ice Damage"
		upgrade_animator.play("Upgrade Got")
	elif Global.lifesteal_achieved and lifesteal_on == false and upgrade_animator.is_playing() == false:
		lifesteal_on = true
		upgrade_text.text = "Lifesteal"
		upgrade_animator.play("Upgrade Got")
	elif Global.aoe_achieved and aoe_on == false and upgrade_animator.is_playing() == false:
		aoe_on = true
		upgrade_text.text = "Starfall"
		upgrade_animator.play("Upgrade Got")
	elif Global.fireball_achieved and fireball_on == false and upgrade_animator.is_playing() == false:
		fireball_on = true
		upgrade_text.text = "Fireball"
		upgrade_animator.play("Upgrade Got")
	elif Global.taming_achieved and taming_on == false and upgrade_animator.is_playing() == false:
		taming_on = true
		upgrade_text.text = "Taming"
		upgrade_animator.play("Upgrade Got")
