extends CharacterBody2D

@export var BASE_SPEED : int = Global.BASE_SPEED
@export var velocity_mod : float = 1
@export var experience_bar : Control
@export var fireball_projectile : PackedScene
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_anim : AnimationPlayer = %AttackAnimation
@onready var timer : Timer = $"I-Frames"
@onready var sword_unsheath : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var DeathMusic : AudioStreamPlayer2D = $DieMusic
@onready var DeathSFX : AudioStreamPlayer2D = $DieSFX
@onready var Dash_Wait : Timer = %Dash_Timer
@onready var dashing_timer : Timer = %"Dash Immunity"
@onready var health_bar : AnimatedSprite2D = $CanvasLayer/Health
@onready var block_reset : Timer = %"Block Reset"
@onready var fireball_cooldown : Timer = %"Fireball Cooldown"
var block = Global.player_block
var auto_pause = false
var dashing = false
var anim_dir : String = "Down"
var dash_cooldown = false
var can_play : bool = true
var dead = false
var health = Global.player_health
var SPEED = Global.SPEED
var lifesteal_percent : float = 200
var enemy = null

var invinsible_unlocked : bool = false
var fire_unlocked : bool = false
var ice_unlocked : bool = false
var lifesteal_unlocked : bool = false
var aoe_unlocked : bool = false
var fireball_unlocked : bool = false
var taming_unlocked : bool = false


func _ready() -> void:
	_check_abilities()
	reset_levels()
	Global.player_health = Global.max_player_health
	Global.player_is_dead = false
	velocity_mod = 1
	Global.SPEED = Global.BASE_SPEED
	pass

# resets buffs when entering game from home screen
func reset_levels():
	# resets health
	Global.player_health = Global.health_reset
	Global.max_player_health = Global.health_reset
	# resets block
	Global.player_block_count = Global.player_block_reset
	Global.player_can_block = Global.can_block_reset
	Global.max_block = Global.max_block_reset
	# resets speeds
	Global.BASE_SPEED = Global.speed_reset
	Global.SPEED = Global.speed_reset
	# resets damage
	Global.damage_mod = Global.damage_mod_reset
	Global.fireball_damage_mod = Global.fireball_mod_reset
	Global.tamed_damge_mod = Global.tame_mod_reset
	# reset levels and points
	Global.player_level = Global.level_reset
	Global.points = Global.points_reset
	Global.exp_mult = Global.exp_reset
	# resets the kill count
	Global.total_kills = Global.total_kill_reset
	Global.caster_kills = Global.caster_kill_reset
	Global.slime_kills = Global.slime_kill_reset

func get_input():
	var direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = direction * Global.SPEED * velocity_mod
	Global.player_x = position.x
	Global.player_y = position.y
	Global.player_direction = direction

func sprint():
	if Input.is_action_pressed("Sprint"):
		velocity_mod = 1.5
		can_play = true
	elif dashing == false:
		velocity_mod = 1

func dash():
	if Input.is_action_pressed("Dash") and can_play and dash_cooldown == false:
		velocity_mod = 5
		Dash_Wait.start()
		dash_cooldown = true
		Global.SPEED = Global.BASE_SPEED
		dashing = true
		dashing_timer.start()
		if invinsible_unlocked:
			timer.start()
			Global.player_invinsible = true

func die():
	if health <= 0 and anim.animation != "Die":
		anim.play("Die")
		Global.SPEED = 0
		dead = true
		Global.player_is_dead = true
		DeathMusic.play()

func _physics_process(_delta: float) -> void:
	if !Global.paused:
		Global.fireball_dir = anim_dir
		die()
		dash()
		sprint()
		get_input()
		move_and_slide()
		animation_player()
		check_anim()
		handle_health()
		experience_bar.visible = true
		health_bar.visible = true

		if fire_unlocked:
			fire_damage()
		if ice_unlocked:
			ice_damage()
		if lifesteal_unlocked:
			lifesteal()
		if aoe_unlocked:
			aoe_damage()
		if fireball_unlocked:
			fireball()
		if taming_unlocked:
			enemy_taming()
	
	else:
		experience_bar.visible = false
		health_bar.visible = false
		
	show_pause_menu()
	
	if dead:
		Global.SPEED = 0


func block_damage():
	Global.player_block_count -= 1
	if Global.player_block_count <= 0:
		Global.player_can_block = false
		block_reset.start()
	pass


func handle_health():
	# starts i-frame timer when hit
	if Global.player_invinsible and timer.is_stopped() and attack_anim.is_playing() == false:
		timer.start()
	health = Global.player_health
	if Global.player_health > 16:
		Global.player_health = 16

# handles animations
func animation_player():
	# stops animation overlap
	if can_play and dead == false:
		# attack animations
		if Input.is_action_just_pressed("Attack"):
				match anim_dir:
					"Down":
						attack_anim.play("Front Attack")
						anim.flip_h = false
					"Up":
						attack_anim.play("Up Attack")
						anim.flip_h = false
					"Right":
						attack_anim.play("Side Attack")
						anim.flip_h = true
					"Left":
						attack_anim.play("Side Attack")
						anim.flip_h = false
				sword_unsheath.play()
		# walking animations
		elif Input.is_action_pressed("Move Down"):
			anim.play("Down Walk")
			anim.flip_h = false
			anim_dir = "Down"
		elif Input.is_action_pressed("Move Up"):
			anim.play("Up Walk")
			anim.flip_h = false
			anim_dir = "Up"
		elif Input.is_action_pressed("Move Right"):
			anim.play("Side Walk")
			anim.flip_h = true
			anim_dir = "Right"
		elif Input.is_action_pressed("Move Left"):
			anim.play("Side Walk")
			anim.flip_h = false
			anim_dir = "Left"
		# idle animations
		elif anim_dir == "Down":
			anim.play("Down Idle")
		elif anim_dir == "Up":
			anim.play("Up Idle")
		elif anim_dir == "Right":
			anim.play("Side Idle")
		elif anim_dir == "Left":
			anim.play("Side Idle")
		else:
			Global.SPEED = Global.BASE_SPEED

func check_anim():
	if anim.animation == "Die" or attack_anim.is_playing():
			can_play = false

func show_pause_menu():
	if Input.is_action_just_pressed("Pause") and Global.leveling_up == false or auto_pause:
		var pause_menu = %"Pause Menu"
		pause_menu.visible = true 
		Global.paused = true
		experience_bar.visible = false
		health_bar.visible = false

func _check_abilities():
	# checks if abilities are activated and calls to activate their affects
	if Global.quick_dash:
		quick_dash()
	if Global.invincible_dash:
		invinsible_unlocked = true
	if Global.fire_damage:
		fire_unlocked = true
	if Global.ice_damage:
		ice_unlocked = true
	if Global.lifesteal:
		lifesteal_unlocked = true
	if Global.aoe_spell:
		aoe_unlocked = true
	if Global.fireball:
		fireball_unlocked = true
	if Global.enemy_taming:
		taming_unlocked = true

func quick_dash():
	Dash_Wait.wait_time -= 0.5

func fire_damage():
	
	pass

func ice_damage():
	
	pass

func lifesteal():
	if attack_anim.is_playing():
		@warning_ignore("narrowing_conversion")
		Global.player_health += (Global.explode_base_damage + Global.damage_mod) * lifesteal_percent

func aoe_damage():
	pass

func fireball():
	if !dead and fireball_cooldown.is_stopped():
		if Input.is_action_just_pressed("Fire Fireball"):
			var new_fireball = fireball_projectile.instantiate()
			add_sibling(new_fireball)
			Global.fireball_dir = anim_dir
			fireball_cooldown.start()

func enemy_taming():
	if !dead and enemy != null:
		if Input.is_action_pressed("Tame"):
			
			Global.player_is_taming = true
		else:
			Global.player_is_taming = false
		enemy.get_tamed()
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation != "Die":
		can_play = true
		Global.SPEED = Global.BASE_SPEED
	else:
		auto_pause = true

# says that this is the player
func player():
	pass


func _on_i_frames_timeout() -> void:
	Global.player_invinsible = false
	pass


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	can_play = true
	Global.SPEED = Global.BASE_SPEED


func _on_die_music_finished() -> void:
	DeathSFX.play()


func _on_dash_timer_timeout() -> void:
	dash_cooldown = false

# says when you are dashing
func _on_dash_immunity_timeout() -> void:
	dashing = false


func _on_pause_menu_resume() -> void:
	experience_bar.visible = true
	health_bar.visible = true


func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy = body


func _on_enemy_detector_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		if Global.taming_achieved and taming_unlocked and enemy != null:
			enemy.remove_text()
		enemy = null


func _on_block_reset_timeout() -> void:
	Global.player_can_block = true
