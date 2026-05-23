extends Control

# set refrences to buttons
@onready var block : Button = %"Block Up"
@onready var damage : Button = %"Damage Up"
@onready var fireball : Button = %"Fireball Damage Up"
@onready var friend : Button = %"Friend Damage Up"
@onready var health : Button = %"Health Up"
@onready var experience : Button = %"Increase Exp Gain"
@onready var speed : Button = %"Speed Up"
var level : int = 0


func _ready() -> void:
	level = 0
	self.visible = false
	turn_it_off()

func turn_it_off():
	block.visible = false
	damage.visible = false
	fireball.visible = false
	friend.visible = false
	health.visible = false
	experience.visible = false
	speed.visible = false

func _process(_delta: float) -> void:
	level_up()

func level_up():
	if level < Global.player_level:
		level = Global.player_level
		Global.paused = true
		self.visible = true
		Global.points += 100
		randomize_upgrades()

func randomize_upgrades():
	var numbers = []
	while numbers.size() < 3:
		var new_number = randi_range(1,7)
		if not numbers.has(new_number):
			numbers.append(new_number)
	if numbers.has(1):
		block.visible = true
	if numbers.has(2):
		damage.visible = true
	if numbers.has(3):
		fireball.visible = true
	if numbers.has(4):
		friend.visible = true
	if numbers.has(5):
		health.visible = true
	if numbers.has(6):
		experience.visible = true
	if numbers.has(7):
		speed.visible = true

func _on_block_up_pressed() -> void:
	@warning_ignore("narrowing_conversion")
	Global.player_block *= 1.1
	Global.player_block += 1
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_damage_up_pressed() -> void:
	@warning_ignore("narrowing_conversion")
	Global.damage_mod *= 1.1
	Global.damage_mod += 5
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_fireball_damage_up_pressed() -> void:
	Global.fireball_damage_mod += 5
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_friend_damage_up_pressed() -> void:
	Global.tamed_damge_mod += 5
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_health_up_pressed() -> void:
	Global.max_player_health += 50
	Global.player_health = Global.max_player_health
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_increase_exp_gain_pressed() -> void:
	Global.exp_mult += 1
	self.visible = false
	Global.paused = false
	turn_it_off()


func _on_speed_up_pressed() -> void:
	Global.SPEED += 50
	Global.BASE_SPEED += 50
	self.visible = false
	Global.paused = false
	turn_it_off()
