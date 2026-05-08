extends CharacterBody2D

@export var BASE_SPEED : int = Global.BASE_SPEED
@export var velocity_mod : float = 1
@onready var anim = $AnimatedSprite2D
@onready var attack_anim = %AttackAnimation
@onready var timer = $"I-Frames"
@onready var sword_unsheath = $AudioStreamPlayer2D
@onready var DeathMusic = $DieMusic
@onready var DeathSFX = $DieSFX
@onready var Dash_Wait = %Dash_Timer
@onready var dash_immunity_timer = %"Dash Immunity"
var dash_immunity = false
var anim_dir : String = "Down"
var dash_cooldown = false
var can_play : bool = true
var dead = false
var health = Global.player_health
var SPEED = Global.SPEED

func _ready() -> void:
	_check_abilities()
	pass

func get_input():
	var direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = direction * Global.SPEED * velocity_mod

func sprint():
	if Input.is_action_pressed("Sprint"):
		velocity_mod = 1.5
		can_play = true
		Global.SPEED = Global.BASE_SPEED
	elif dash_immunity == false:
		velocity_mod = 1

func dash():
	if Input.is_action_pressed("Dash") and can_play and dash_cooldown == false:
		velocity_mod = 5
		Dash_Wait.start()
		dash_cooldown = true
		Global.SPEED = Global.BASE_SPEED
		dash_immunity = true
		dash_immunity_timer.start()
		

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
	show_pause_menu()

	if dead:
		Global.SPEED = 0
func handle_health():
	# starts i-frame timer when hit
	if Global.player_invinsible and timer.is_stopped() and attack_anim.is_playing() == false:
		timer.start()
		
	health = Global.player_health

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
	pass
	if Input.is_action_just_pressed("Pause"):
		var pause_menu = %"Pause Menu"
		pause_menu.visible = true
		Global.paused = true

func _check_abilities():
	# checks if abilities are activated and calls to activate their affects
	if Global.quick_dash:
		print("quickly dashing ing ing")
		quick_dash()
	if Global.invincible_dash:
		invinsible_dash()
	if Global.fire_damage:
		fire_damage()
	if Global.ice_damage:
		ice_damage()
	if Global.lifesteal:
		lifesteal()
	if Global.aoe_spell:
		aoe_damage()
	if Global.fireball:
		fireball()
	if Global.enemy_taming:
		enemy_taming()

func quick_dash():
	Dash_Wait.wait_time -= 0.5
	print("quickly dashing")

func invinsible_dash():
	timer.play()

func fire_damage():
	
	pass

func ice_damage():
	pass

func lifesteal():
	pass

func aoe_damage():
	pass

func fireball():
	pass

func enemy_taming():
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation != "Die":
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


func _on_dash_immunity_timeout() -> void:
	dash_immunity = false
