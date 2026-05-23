extends Node

var points : int = 0
var max_points : int = 0

# resets for variables
var points_reset : int = 0
var health_reset : int = 50
var speed_reset : int = 100
var damage_mod_reset : int = 0
var tame_mod_reset : int = 0
var fireball_mod_reset : int = 0
var experience_reset : int = 0
var max_exp_reset : int = 100
var block_reset : int = 0
var exp_reset : float = 1
var level_reset : int = 0

var exp_mult : float = 1
var player_block : int = 0
var max_player_health : int = 50
var player_health : float = 50
var player_max_health : int = 50
var player_is_dead : bool = false
var player_invinsible : bool = false
var explode_base_damage : int = 5
var player_experience : int = 0
var player_experience_to_level_up : int = 100
var player_level : int = 0
var SPEED : int = 100
var BASE_SPEED : int = 100
var paused : bool = false
var damage_mod : int = 0

var tamed_damge_mod : int = 0
var fireball_damage_mod : int = 0
var friend_slime_base_damage : int = 5
var fireball_base_damage : int = 10

var player_is_taming : bool = false

var player_direction : Vector2
var player_x : float = 0.0
var player_y : float = 0.0

# different abilities and the dictionary containing all of their data.
var quick_dash : bool = false
var invincible_dash : bool = false
var fire_damage : bool = false
var ice_damage : bool = false
var lifesteal : bool = false
var aoe_spell : bool = false
var fireball : bool = false
var enemy_taming : bool = false
var ability_list : Dictionary = {
	"quick_dash" : {
		"quick_selected" : false, "quick_activated" : quick_dash
	},
	"invincible_dash" : {
		"invincible_selected" : false, "invincible_activated" : invincible_dash
	},
	"fire_damage" : {
		"fire_selected" : false, "fire_activated" : fire_damage
	},
	"ice_damage" : {
		"ice_selected" : false, "ice_activated" : ice_damage
	},
	"lifesteal" : {
		"lifesteal_selected" : false, "lifesteal_activated" : lifesteal
	},
	"aoe_spell" : {
		"aoe_selected" : false, "aoe_activated" : aoe_spell
	},
	"fireball" : {
		"fireball_selected" : false, "fireball_activated" : fireball
	},
	"enemy_taming" : {
		"taming_selected" : false, "taming_activated" : enemy_taming
	}
}

var quick_achieved = false
var invincible_achieved = false
var fire_achieved = false
var ice_achieved = false
var lifesteal_achieved = false
var aoe_achieved = false
var fireball_achieved = false
var taming_achieved = false


# enemy damage ammounts
var slime_damage : int = 5

func _process(_delta: float) -> void:
	check_achievements()
	handle_points()

# check for achievements
func check_achievements():
	
	if max_points >= 100 and max_points < 500:
		fireball_achieved = true
	elif max_points >= 500 and max_points < 1000:
		fireball_achieved = true
		taming_achieved = true
		quick_achieved = true
	elif max_points >= 1000:
		# old achievements
		fireball_achieved = true
		taming_achieved = true
		quick_achieved = true
		
		# new achievements
		invincible_achieved = true
		fire_achieved = true
		ice_achieved = true
		lifesteal_achieved = true
		aoe_achieved = true
		
	

func handle_points():
	if max_points < points:
		max_points = points
