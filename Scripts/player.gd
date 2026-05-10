extends CharacterBody2D

@export var BASE_SPEED : int = Global.BASE_SPEED
@export var velocity_mod : float = 1
@export var experience_bar : Control
@export var fireball_projectile : PackedScene
@onready var anim = $AnimatedSprite2D
@onready var attack_anim = %AttackAnimation
@onready var timer = $"I-Frames"
@onready var sword_unsheath = $AudioStreamPlayer2D
@onready var DeathMusic = $DieMusic
@onready var DeathSFX = $DieSFX
@onready var Dash_Wait = %Dash_Timer
@onready var dashing_timer = %"Dash Immunity"
var dashing = false
var anim_dir : String = "Down"
var dash_cooldown = false
var can_play : bool = true
var dead = false
var health = Global.player_health
var SPEED = Global.SPEED
var lifesteal_percent : float = 200

var invinsible_unlocked = false
var fire_unlocked = false
var ice_unlocked = false
var lifesteal_unlocked = false
var aoe_unlocked = false
var fireball_unlocked = false
var taming_unlocked = false


func _ready() -> void:
	_check_abilities()
	Global.player_health = Global.max_player_health
	Global.player_is_dead = false
	velocity_mod = 1
	Global.SPEED = Global.BASE_SPEED
	pass

func get_input():
	var direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = direction * Global.SPEED * velocity_mod
	Global.player_x = position.x
	Global.player_y = position.y
	Global.player_velocity = velocity/velocity_mod

func sprint():
	if Input.is_action_pressed("Sprint"):
		velocity_mod = 1.5
		can_play = true
		Global.SPEED = Global.BASE_SPEED
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
		die()
		dash()
		sprint()
		get_input()
		move_and_slide()
		animation_player()
		check_anim()
		handle_health()
		
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
	
	show_pause_menu()
	
	if dead:
		Global.SPEED = 0
func handle_health():
	# starts i-frame timer when hit
	if Global.player_invinsible and timer.is_stopped() and attack_anim.is_playing() == false:
		timer.start()
	health = Global.player_health
	if Global.player_health > Global.player_max_health:
		Global.player_health = Global.player_max_health

# handles animations
func animation_player():
	# stops animation overlap
	if can_play and dead == false:
		# attack animations
		if Input.is_action_just_pressed("Attack"):
				attack_anim.play("Attack")
				print("invincible")
				Global.SPEED = 0
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
			anim.flip_h = false
			anim_dir = "Right"
		elif Input.is_action_pressed("Move Left"):
			anim.play("Side Walk")
			anim.flip_h = true
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
	if Input.is_action_just_pressed("Pause"):
		var pause_menu = %"Pause Menu"
		pause_menu.visible = true
		Global.paused = true
		experience_bar.visible = false

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
	print("BBBBBBB")
	Dash_Wait.wait_time -= 0.5
	print("quickly dashing")

func fire_damage():
	
	pass

func ice_damage():
	
	pass

func lifesteal():
	print("lifesteal is", lifesteal_unlocked)
	print("aoe is", aoe_unlocked)
	print("can steal life")
	if attack_anim.is_playing():
		print("stealing life")
		Global.player_health += Global.explode_damage * lifesteal_percent

func aoe_damage():
	print("aoe_damage")
	pass

func fireball():
	if Input.is_action_just_pressed("Fire Fireball"):
		print("shoot fireball")
		var new_fireball = fireball_projectile.instantiate()
		add_sibling(new_fireball)

func enemy_taming():
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation != "D!e":
		can_play = true
		Global.SPEED = Global.BASE_SPEED

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
