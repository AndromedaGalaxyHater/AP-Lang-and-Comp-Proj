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
	if velocity == Vector2(0,0):
		match Global.fireball_dir:
			"Up":
				velocity = Vector2(0,-1) * FIREBALL_SPEED
				direction = Vector2(0,-1)
			"Down":
				velocity = Vector2(0,1) * FIREBALL_SPEED
				direction = Vector2(0,1)
			"Left":
				velocity = Vector2(-1,0) * FIREBALL_SPEED
				direction = Vector2(-1,0)
			"Right":
				velocity = Vector2(1,0) * FIREBALL_SPEED
				direction = Vector2(1,0)
	# modifies animation
	anim.rotation = direction.angle()


func _physics_process(_delta: float) -> void:
	if Global.paused == false:
		move_and_slide()

func _on_fireball_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		anim.play("Explode")
		explosion_sfx.play()
		body.take_damage("fireball")
		velocity = Vector2(0,0)
	# doesn't work needs to detect other body
	elif body.has_method("enemy_fireball"):
		anim.play("Explode")
		explosion_sfx.play()
		velocity = Vector2(0,0)


func _on_explosion_sound_finished() -> void:
	queue_free()

# calls the object with the script a fireball
func fireball():
	pass


func _on_fireball_area_area_entered(area: Area2D) -> void:
	if str(area.name) == "Fireball Area":
		anim.play("Explode")
		explosion_sfx.play()
		velocity = Vector2(0,0)


func _on_fireball_animations_animation_finished() -> void:
	if anim.animation == "Explode":
		queue_free()
