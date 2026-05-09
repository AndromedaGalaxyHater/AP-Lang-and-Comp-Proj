extends CharacterBody2D

@export var player : PackedScene

func _ready() -> void:
	self.position.x = player.position.x
	self.position.y = player.position.y
