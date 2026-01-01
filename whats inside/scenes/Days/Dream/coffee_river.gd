extends Node2D

@onready var space_button = $SpaceBar
@onready var player = $Player
@onready var player_jump = $PlayerIdleRight
var on_jump_pad = false

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact") and on_jump_pad:
		jump()

func _on_jump_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		on_jump_pad = true

func _on_jump_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		on_jump_pad = false

func jump():
	on_jump_pad = false
	player.can_move = false
	player.visible = false
	player_jump.position = player.position
	player_jump.visible = true
	space_button.get_node("Sprite2D").frame = 0
	space_button.interactable = false
	jump_tween()

func jump_tween():
	var tween = create_tween()
	var current_y = player.position.y
	tween.tween_property(player_jump, "position:y", current_y - 10, 0.2)
	tween.tween_property(player_jump, "position:y", current_y, 1)
	tween.set_parallel()
	tween.tween_property(player_jump, "position:x", 222, 2)
