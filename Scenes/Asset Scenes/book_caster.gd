extends CharacterBody2D


const SPEED = 100.0

@export var fireball : PackedScene

@onready var anim : AnimatedSprite2D = %Animator
@onready var cooldown : Timer = %Fireball_Cooldown
@onready var wander : Timer = %"Wander Timer"
@onready var modulate_timer : Timer = %modulate_timer

var spawner
var player_too_close : bool = false
var tame_too_close : bool = false
var player_just_right : bool = false
var tame_just_right : bool = false
var player = null
var tame = null
var idle_dir : Vector2
var health : int = 15
var dead : bool = false
var score : int = 75
var death_xp : int = 75
var can_move : bool = true



func _process(_delta: float) -> void:
	if !dead and Global.player_is_dead == false and Global.paused == false:
		if cooldown.is_stopped() and player != null:
			anim.play("Cast Fireball")
			can_move = false
		if can_move:
			handle_movement()
		handle_anim()
		handle_health()

# handles animations
func handle_anim():
	if anim.animation != "Cast Fireball" and anim.animation != "Leave Fireball" and !dead:
		if velocity.y < -1:
			anim.play("Back Idle")
		else:
			anim.play("Front Idle")


func take_damage(type : String):
	match type:
		"explosion":
			health -= Global.explode_base_damage + Global.damage_mod
		"fireball":
			health -= Global.fireball_base_damage + Global.tamed_damge_mod
		"friendly slime":
			health -= Global.friend_slime_base_damage + Global.tamed_damge_mod
	modulate = "ff0000"
	modulate_timer.start()


func handle_movement():
	# deals with player interactions first
	# go to player when far away
	if player != null and player_too_close == false and player_just_right == false:
		var direction = self.global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
	# runs away when too close
	elif player != null and player_too_close == true:
		var direction = self.global_position.direction_to(player.global_position)
		velocity = direction * SPEED * -1
		move_and_slide()
	elif tame != null and tame_too_close == false:
		var direction = self.global_position.direction_to(tame.global_position)
		velocity = direction * SPEED
	elif tame != null and tame_too_close == false:
		var direction = self.global_position.direction_to(tame.global_position)
		velocity = direction * SPEED
	# idles when no one is around
	elif player == null and tame == null:
		if wander.is_stopped():
			wander.start()
		velocity = idle_dir * SPEED
		move_and_slide()

# deals with health and calls die()
func handle_health():
	if health <= 0:
		die()


func die():
	anim.play("Die")
	spawner.enemy_died()
	Global.points += score
	Global.player_experience += death_xp
	dead = true


func fire_fireball():
	var new_fireball = fireball.instantiate()
	add_sibling(new_fireball)
	new_fireball.spawn(self.position)


func _on_animator_animation_finished() -> void:
	if anim.animation == "Cast Fireball" and !dead:
		anim.play("Leave Fireball")
		cooldown.start()
		fire_fireball()
	elif anim.animation == "Leave Fireball" and !dead:
		anim.play("Front Idle")
		can_move = true
	elif anim.animation == "Die":
		Global.total_kills += 1
		Global.caster_kills += 1
		queue_free()


func get_tamed():
	pass


func remove_text():
	pass

# calls the spawner and sets it
func name_spawner(spawn_point):
	spawner = spawn_point
	pass


# checks if player/friend enter attack range
func _on_close_check_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_too_close = true
	if body.has_method("friend"):
		tame_too_close = true

# checks if player/friend leave attack range
func _on_close_check_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_too_close = false
	if body.has_method("friend"):
		tame_too_close = false

# checks if damaging moves come in contact
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if str(area.name) == "Explosion Area":
		take_damage("explosion")


func _on_detector_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
	if body.has_method("friend"):
		tame = body


func _on_detector_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
	if body.has_method("friend"):
		tame = null


func _on_goldilocks_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_just_right = true
	elif body.has_method("friend"):
		tame_just_right = true


func _on_goldilocks_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_just_right = false
	elif body.has_method("friend"):
		tame_just_right = false


func _on_wander_timer_timeout() -> void:
	idle_dir = Vector2(randi_range(-1,1),randi_range(-1,1))

# says this is an enemy
func enemy():
	pass


func _on_modulate_timer_timeout() -> void:
	modulate = "ffffff"
