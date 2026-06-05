extends CharacterBody2D


const SPEED = 100.0
const DAMAGE = 2
@onready var anim : AnimatedSprite2D = %Animator


func spawn(caster_position):
	self.position = caster_position
	var direction = self.position.direction_to(Vector2(Global.player_x,Global.player_y))
	velocity = direction * SPEED
	anim.rotation = direction.angle() - 90


func _physics_process(_delta: float) -> void:
	if Global.paused == false:
		move_and_slide()
	if velocity == Vector2(0,0):
		anim.play("explosion")

# says that what has this as a method is the enemies fireball
func enemy_fireball():
	pass


func _on_fireball_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		anim.play("explosion")
		if Global.player_can_block:
			body.block_damage()
		else:
			Global.player_health -= Global.book_damage
		velocity = Vector2(0,0)
	elif body.has_method("friend"):
		anim.play("explosion")
		body.take_damage("explosion")


func _on_fireball_area_area_entered(area: Area2D) -> void:
	if str(area.name) == "fireball area":
		anim.play("explosion")
		velocity = Vector2(0,0)


func _on_animator_animation_finished() -> void:
	if anim.animation == "explosion":
		queue_free()


func _on_fireball_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name == "décor":
		anim.play("explosion")
		velocity = Vector2(0,0)
