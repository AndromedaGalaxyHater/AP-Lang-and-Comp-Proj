extends CharacterBody2D

@export var BASE_SPEED : int = 50
@onready var anim = $AnimatedSprite2D
@onready var immune_timer = $"Immunity Timer"
@onready var hit_sfx = $HitSFX
@onready var attack_sfx = $AttackSFX
@onready var velocity_timer = $"velocity timer"
@onready var idle_timer = %"Idle Timer"

var tame = null
var tame_fight : bool = false
var SPEED : int = 25
var player = null
var can_attack : bool = false
var slime_dir : String = "Down"
var health : int = 15
var immunity : bool = false
var can_animate : bool = false
var velocity_mod : int = 1
var enemy_exp : int = 50
var idle_vector : Vector2 = Vector2(0,1)

func _physics_process(_delta: float) -> void:
	if !Global.paused:
		attack()
		animations()
		get_dir()
		handle_health()
		if tame != null:
			var direction = global_position.direction_to(tame.global_position)
			velocity = direction * SPEED * velocity_mod
			move_and_slide()
		elif player != null and Global.player_is_dead == false:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * SPEED * velocity_mod
			print(global_position.direction_to(player.global_position))
			move_and_slide()
			idle_timer.stop()
		elif Global.player_is_dead == false:
			if idle_timer.is_stopped():
				idle_timer.start()
			velocity = idle_vector * SPEED * velocity_mod
			move_and_slide()

# handles health
func handle_health():
	if health <= 0:
		if anim.animation != "Die":
			anim.play("Die")
		health = 0
		# stops all animations and movement
		can_animate = false
		SPEED = 0

# handles attacking
func attack():
	if health > 0:
		if can_attack and Global.player_health > 0 and Global.player_invinsible == false and (Global.slime_damage - Global.player_block) > 0:
			Global.player_health -= (Global.slime_damage - Global.player_block)
			Global.player_invinsible = true
			attack_sfx.play()
		if tame_fight and tame != null and tame.immunity == false:
			tame.take_damage("slime")

# finds the direction of the slime
func get_dir():
	if abs(velocity.x) >= abs(velocity.y):
		if velocity.x > 0:
			slime_dir = "Right"
		elif velocity.x < 0:
			slime_dir = "Left"
		else:
			pass
	else:
		if velocity.y > 0:
			slime_dir = "Down"
		else:
			slime_dir = "Up"

# handles animations
func animations():
# Walking animations
	if player != null and can_animate:
		match slime_dir:
			"Down":
				anim.play("Down Jump")
				anim.flip_h = false
			"Up":
				anim.play("Up Jump")
				anim.flip_h = false
			"Right":
				anim.play("Side Jump")
				anim.flip_h = false
			"Left":
				anim.play("Side Jump")
				anim.flip_h = true
# Idle animations
	elif player == null and can_animate:
		match slime_dir:
			"Down":
				anim.play("Down Idle")
				anim.flip_h = false
			"Up":
				anim.play("Up Idle")
				anim.flip_h = false
			"Right":
				anim.play("Side Idle")
				anim.flip_h = false
			"Left":
				anim.play("Side Idle")
				anim.flip_h = true

# handles being attacked
func take_damage(type):
	if type == "explosion":
		health -= Global.explode_base_damage + Global.fireball_damage_mod
	elif type == "fireball":
		health -= Global.fireball_base_damage + Global.damage_mod
	elif type == "friendly slime":
		health -= Global.friend_slime_base_damage + Global.tamed_damge_mod
	immunity = true
	immune_timer.start()
	hit_sfx.play()
	velocity_mod = -2
	velocity_timer.start()

# says when player is nearby
func _on_detector_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
	if body.has_method("friend"):
		tame = body

# says when player leaves
func _on_detector_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
	if body.has_method("friend"):
		tame = null

# says when player enters attack range
func _on_attack_check_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		can_attack = true
	if body.has_method("friend"):
		tame_fight = true

# says when player leaves attack range
func _on_attack_check_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		can_attack = false
	if body.has_method("friend"):
		tame_fight = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if str(area.name) == "Explosion Area" and immunity == false and health > 0:
		take_damage("explosion")

func _on_immunity_timer_timeout() -> void:
	immunity = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "Spawn In":
		can_animate = true
	if anim.animation == "Die":
		@warning_ignore("narrowing_conversion")
		Global.player_experience += enemy_exp * Global.exp_mult
		queue_free()


func _on_velocity_timer_timeout() -> void:
	velocity_mod = 1

func enemy():
	pass


func _on_idle_timer_timeout() -> void:
	idle_vector = Vector2(randi_range(-1,1), randi_range(-1,1))
	print("changed to", idle_vector)
