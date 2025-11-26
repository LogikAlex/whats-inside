extends Area2D

@export var wanted_room_path: String

var player_node: CharacterBody2D = null

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_room_transition()

func _room_transition():
	var trans_tween = create_tween()
	var blackScreen = player_node.get_node("Camera2D/BlackScreen")
	trans_tween.tween_property(blackScreen, "modulate:a", 1, 0.5)
	trans_tween.tween_callback(
	func _change_room():
		get_tree().change_scene_to_file(wanted_room_path)
	)
