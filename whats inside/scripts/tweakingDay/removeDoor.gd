extends Area2D

@onready var wall: TileMapLayer = $"../DoorGone"

func _on_area_entered(_area: Area2D) -> void:
	wall.visible = true
