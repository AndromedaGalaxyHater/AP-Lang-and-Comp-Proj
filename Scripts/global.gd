extends Node

var health_reset : int = 50
var speed_reset : int = 100
var damage_mod_reset : int = 0
var tame_mod_reset : int = 0
var fireball_mod_reset : int = 0


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
