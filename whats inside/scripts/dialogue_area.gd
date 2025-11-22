extends Area2D

const DialogueSystemPreload = preload("res://scenes/dialogue_system.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var override_dialogue_position: bool
@export var override_position: Vector2
@export var dialogue: Array[DE]

var dialogue_pos: Vector2

var chose_position: bool = false
var player_body_in: bool = false
var has_activated_already: bool = false
var desired_dialogue_pos: Vector2

var player_node: CharacterBody2D = null

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i

func _process(_delta: float) -> void:
	if !player_node:
		for i in get_tree().get_nodes_in_group("player"):
			player_node = i
		return
	
	if !chose_position:
		dialogue_pos.x = player_node.position.x
		dialogue_pos.y = player_node.position.y
		print(dialogue_pos)
		chose_position = true
	
	if !activate_instant and player_body_in:
		if only_activate_once and has_activated_already:
			set_process(false)
			return
		
		if Input.is_action_just_released("interact"):
			_activate_dialogue()
			has_activated_already = true
			player_body_in = false

func _activate_dialogue() -> void:
	player_node.can_move = false
	player_node.interact_indicator_disappear()
	
	var new_dialogue = DialogueSystemPreload.instantiate()
	if override_dialogue_position:
		desired_dialogue_pos = override_position
	else:
		desired_dialogue_pos = dialogue_pos
	new_dialogue.dialogue = dialogue
	get_parent().add_child(new_dialogue)

func _on_area_entered(area: Area2D) -> void:
	if only_activate_once and has_activated_already:
		return
	if area.is_in_group("interact_hitbox_player"):
		player_node.interact_indicator_appear()
		player_body_in = true
		if activate_instant:
			_activate_dialogue()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("interact_hitbox_player"):
		player_node.interact_indicator_disappear()
		player_body_in = false

#func _on_body_entered(body: Node2D) -> void:
#	if only_activate_once and has_activated_already:
#		return
#	if body.is_in_group("interact_hitbox_player"):
#		player_body_in = true
#		if activate_instant:
#			_activate_dialogue()

#func _on_body_exited(body: Node2D) -> void:
#	if body.is_in_group("interact_hitbox_player"):
#		player_body_in = false
