extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var blameDialogue: CollisionShape2D = $blameDialog/CollisionShape2D
@onready var couchLight: PointLight2D = $couchLight
@onready var tvWatchFunc: CollisionShape2D = $tv_watch/trigger_watch_tv
@onready var playerOnCouch: Sprite2D = $Player_on_couch
@onready var tvLight: PointLight2D = $tvLight
@onready var ambience: CanvasModulate = $ambience
@onready var blackScreen: Sprite2D = $BlackScreen/Sprite2D

func _ready() -> void:
	if globals.livingroomBlame:
		blameDialogue.disabled = false
	if globals.checkedAll:
		couchLight.enabled = true
		tvWatchFunc.disabled = false

func set_false():
	globals.livingroomBlame = false
	player.can_move = true

func sitOnCouch():
	player.can_move = false
	var watch = create_tween()
	watch.set_parallel()
	watch.tween_property(couchLight, "energy", 0, 1.5)
	watch.tween_property(playerOnCouch, "visible", true, 0).set_delay(2)
	watch.tween_property(player, "visible", false, 0).set_delay(2)
	watch.tween_property(tvLight, "enabled", true, 0).set_delay(4)
	watch.tween_property(ambience, "color", Color8(45, 51, 76), 5).set_delay(8)
	watch.tween_property(ambience, "color", Color8(50, 47, 54), 5).set_delay(11)
	watch.tween_property(blackScreen, "modulate:a", 1, 3).set_delay(11)
