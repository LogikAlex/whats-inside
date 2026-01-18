extends Area2D

@export var crack_sprite: AnimatedSprite2D
@onready var camera: Camera2D = $"../Camera2D"
@onready var crack_sound: AudioStreamPlayer2D = $crack_sound


var can_trigger = true

func _ready() -> void:
	pass # Replace with function body.


func _on_area_entered(_area: Area2D) -> void:
	if can_trigger:
		can_trigger = false
		crack_sprite.visible = true
		crack_sprite.play("crack_anim")
		crack_sound.play()
		cam_shake()

func cam_shake():
	var shake_tween = create_tween()
	shake_tween.tween_property(camera, "offset", Vector2(2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(-2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(0, 0), 0.09)
