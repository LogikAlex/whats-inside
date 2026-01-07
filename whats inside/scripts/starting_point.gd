extends Node2D

var canGetUp = false

func _ready() -> void:
	#globals.wokeUpDream = true
	if globals.wokeUpDream:
		$bed.get_node("Sprite2D").frame = 0
		$Player.can_move = true
		$Player.visible = true
		$Camera2D.zoom = Vector2(1.1, 1.1)
		$Camera2D.position = Vector2(172, 105)
		$InteractIndicator.visible = false
	else:
		$Camera2D.zoom = Vector2(2, 2)
		$Camera2D.position = Vector2(105, 105)
		$InteractIndicator.modulate.a = 0
		$bed.get_node("Sprite2D").frame = 1
		$Player.can_move = false
		$Player.position = Vector2(121, 110)
		$bed.get_node("Sprite2D").modulate.a = 0
		$DreamSqTerrainBed.modulate.a = 0
		$bedsideCabinet.get_node("Sprite2D").modulate.a = 0
		cutscene()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact") and canGetUp:
		canGetUp = false
		fadeOutInteract()
		$Player.visible = true
		$Player.can_move = true
		$Player.current_dir = $Player.directions.DOWN
		$bed.get_node("Sprite2D").frame = 0
		globals.wokeUpDream = true

func cutscene():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($bed.get_node("Sprite2D"), "modulate:a", 1, 3).set_delay(4)
	tween.tween_property($bedsideCabinet.get_node("Sprite2D"), "modulate:a", 1, 3).set_delay(8)
	tween.tween_property($Camera2D, "zoom", Vector2(1.1, 1.1), 5).set_delay(9)
	tween.tween_property($Camera2D, "position", Vector2(172, 105), 5).set_delay(9)
	tween.tween_property($DreamSqTerrainBed, "modulate:a", 1, 5).set_delay(14)
	tween.tween_property($dust, "emitting", true, 0).set_delay(16)
	tween.tween_property($InteractIndicator, "modulate:a", 1, 3).set_delay(20)
	tween.tween_callback(
	func keva():
		$InteractIndicator.isUpdating = true
		canGetUp = true
	).set_delay(23.05)

func fadeOutInteract():
	var fadeOutTween = create_tween()
	$InteractIndicator.isUpdating = false
	$InteractIndicator.frame = 0
	fadeOutTween.tween_property($InteractIndicator, "modulate:a", 0, 1)
