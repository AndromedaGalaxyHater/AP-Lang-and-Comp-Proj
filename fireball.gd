extends CharacterBody2D

@onready var player = load("res://Scenes/Asset Scenes/Player.tscn")
@onready var anim : AnimatedSprite2D = %fireball_animations

func _ready() -> void:
	self.position.x = Global.player_x
	self.position.y = Global.player_y


func _physics_process(_delta: float) -> void:
	velocity = Global.player_velocity

func _on_fireball_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		anim.play("Explode")
		body.take_damage("fireball")


func _on_fireball_animations_animation_finished() -> void:
	if anim.animation == "Explode":
		queue_free()
