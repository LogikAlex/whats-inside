extends Node2D

@onready var space_button = $SpaceBar
@onready var player = $Player
@onready var player_jump = $PlayerIdleRight
@onready var postJumpDialogue = $DialogueArea/CollisionShape2D
var on_jump_pad = false

func _ready() -> void:
	if globals.jumped == true:
		postJumpDialogue.disabled = false
		space_button.get_node("Sprite2D").frame = 0
		space_button.interactable = false


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
	var tween_length = 1.0
	var tween = create_tween()
	var current_y = player.position.y
	tween.set_parallel()
	tween.tween_property(player_jump, "position:y", current_y - 22, tween_length/2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player_jump, "position:y", current_y, tween_length/2).set_delay((tween_length/2) - 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player_jump, "position:x", 220, tween_length).set_ease(Tween.EASE_OUT_IN)
	tween.tween_callback(
	func _after():
		globals.jumped = true
		player_jump.visible = false
		player.position = player_jump.position
		player.visible = true
		player.can_move = true
		postJumpDialogue.disabled = false
		player.current_dir = player.directions.RIGHT
	).set_delay(tween_length + 0.1)
