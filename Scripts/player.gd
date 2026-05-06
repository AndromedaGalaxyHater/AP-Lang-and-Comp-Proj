extends CharacterBody2D

@export var BASE_SPEED : int = Global.BASE_SPEED
@export var velocity_mod : float = 1
@onready var anim = $AnimatedSprite2D
@onready var attack_anim = $AnimationPlayer
@onready var timer = $"I-Frames"
@onready var sword_unsheath = $AudioStreamPlayer2D
@onready var DeathMusic = $DieMusic
@onready var DeathSFX = $DieSFX
var anim_dir : String = "Down"
var can_play : bool = true
var dead = false
var health = Global.player_health
var SPEED = Global.SPEED



func get_input():
	var direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = direction * Global.SPEED * velocity_mod

func sprint():
	if Input.is_action_pressed("Sprint"):
		velocity_mod = 1.5
		can_play = true
		Global.SPEED = Global.BASE_SPEED
	else:
		velocity_mod = 1

func die():
	if health <= 0 and anim.animation != "Die":
		anim.play("Die")
		Global.SPEED = 0
		dead = true
		Global.player_is_dead = true
		DeathMusic.play()

func _physics_process(_delta: float) -> void:
	die()
	sprint()
	get_input()
	move_and_slide()
	animation_player()
	check_anim()
	handle_health()
	
	if dead:
		Global.SPEED = 0
func handle_health():
	# starts i-frame timer when hit
	if Global.player_invinsible and timer.is_stopped():
		timer.start()
		
	health = Global.player_health

# handles animations
func animation_player():
	# stops animation overlap
	if can_play and dead == false:
		# attack animations
		if Input.is_action_just_pressed("Attack"):
			match anim_dir:
				"Down":
					attack_anim.play("Down Attack")
					Global.SPEED = 0
					sword_unsheath.play()
				"Up":
					attack_anim.play("Up Attack")
					Global.SPEED = 0
					sword_unsheath.play()
				"Right":
					attack_anim.play("Right Attack")
					Global.SPEED = 0
					sword_unsheath.play()
				"Left":
					attack_anim.play("Left Attack")
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
	match anim.animation:
			"Down Attack":
				can_play = false
			"Up Attack":
				can_play = false
			"Side Attack":
				can_play = false
			"Die":
				can_play = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation != "Die":
		can_play = true
		Global.SPEED = Global.BASE_SPEED

# says that this is the player
func player():
	pass


func _on_i_frames_timeout() -> void:
	Global.player_invinsible = false


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	can_play = true
	Global.SPEED = Global.BASE_SPEED


func _on_die_music_finished() -> void:
	DeathSFX.play()
