extends Node2D

@onready var silly_guy: AnimatedSprite2D = $silly_guy
@onready var interaction_sprites: Sprite2D = $InteractionSprites
@onready var instructions: Label = $interact_instruction
@onready var or_text: Label = $or
@onready var camera: Camera2D = $Camera2D
@onready var sound: AudioStreamPlayer2D = $sound

func _ready() -> void:
	silly_guy.play("default")
	silly_guy.modulate.a = 0;
	interaction_sprites.modulate.a = 0;
	instructions.modulate.a = 0;
	or_text.modulate.a = 0;
	hint_tween()

func hint_tween():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(silly_guy, "modulate:a", 1, 2).set_delay(1)
	tween.tween_property(instructions, "modulate:a", 1, 2).set_delay(1)
	tween.tween_property(interaction_sprites, "position", Vector2(133.0, 110.0), 2.2).set_delay(2)
	tween.tween_property(interaction_sprites, "modulate:a", 1, 2).set_delay(2)
	tween.tween_property(or_text, "modulate:a", 1, 2).set_delay(2)
	
	tween.tween_property(silly_guy, "modulate:a", 0, 4).set_delay(10)
	tween.tween_property(instructions, "modulate:a", 0, 4).set_delay(10)
	tween.tween_property(interaction_sprites, "modulate:a", 0, 4).set_delay(10)
	tween.tween_property(or_text, "modulate:a", 0, 4).set_delay(10)
	
	tween.tween_callback(
	func finish():
		cam_shake()
		sound.play()
	).set_delay(7.5)
	
	tween.tween_callback(
	func finish():
		get_tree().change_scene_to_file("res://scenes/Days/DayOne/d1_bedroom.tscn")
	).set_delay(17)

func cam_shake():
	var shake_tween = create_tween()
	shake_tween.tween_property(camera, "offset", Vector2(2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(-2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(0, 0), 0.09)
