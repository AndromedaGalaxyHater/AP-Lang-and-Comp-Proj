extends CharacterBody2D

@onready var player = load("res://Scenes/Asset Scenes/Player.tscn")
@onready var anim : AnimatedSprite2D = %fireball_animations
@onready var explosion_sfx : AudioStreamPlayer2D = %"Explosion Sound"

var FIREBALL_SPEED = 150
var last_dir : Vector2 = Vector2(0,1)

func _ready() -> void:
	self.position.x = Global.player_x
	self.position.y = Global.player_y
	var direction = Global.player_direction
	velocity = direction * FIREBALL_SPEED
	if direction != Vector2(0,0):
		last_dir = direction
	if direction == Vector2(0,0):
		velocity = last_dir * FIREBALL_SPEED
	if direction == Vector2(-1,0):
		anim.flip_h = true
		anim.rotation = 0
	elif direction == Vector2(1,0):
		anim.flip_h = false
		anim.rotation = 0
	elif direction == Vector2(0,-1):
		anim.rotation = -90
	elif direction == Vector2 (0,1):
		anim.rotation = 90
	elif direction.x > 0 and direction.y < 0:
		anim.rotation = -45
		anim.flip_h = false
	elif direction.x < 0 and direction.y < 0:
		anim.rotation = 45
		anim.flip_h = true
	elif direction.x < 0 and direction.y > 0:
		anim.rotation = -45
		anim.flip_h = true
	elif direction.x > 0 and direction.y > 0:
		anim.rotation = 45
		anim.flip_h = false


func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_fireball_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		anim.play("Explode")
		explosion_sfx.play()
		body.take_damage("fireball")


func _on_explosion_sound_finished() -> void:
	queue_free()
