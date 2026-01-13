extends Node2D

#Box dialogues
@onready var boxDialogue1 = $box_dialog/CollisionShape2D
@onready var boxDialogue2 = $box_dialog2/CollisionShape2D
@onready var boxDialogue3 = $box_dialog3/CollisionShape2D
@onready var boxDialogue4 = $box_dialog4/CollisionShape2D

#TV specific
@onready var playerCouch: Sprite2D = $Player_on_couch
@onready var interactIndicator: Sprite2D = $InteractIndicator
@onready var sitOnCouchTimer: Timer = $SitOnCouchTimer
@onready var watchingTvDialogue: CollisionShape2D = $tv_dialogue/dialogue
@onready var ambience: CanvasModulate = $ambience
@onready var tvLight: PointLight2D = $tvLight
@onready var tvTrigger: CollisionShape2D = $tv_watch/trigger_watch_tv


#Other objects
@onready var pictureDialoguePreFall = $picture_dialog_prefall/CollisionShape2D
@onready var newCracks: Sprite2D = $FloorCracks
@onready var player: CharacterBody2D = $Player
@onready var picture: Sprite2D = $Picture
@onready var brokenPicture: Sprite2D = $BrokenPicture
@onready var pictureDialogue: CollisionShape2D = $picture_dialog/CollisionShape2D
@onready var pictureCheckDialogue: CollisionShape2D = $picture_check/CollisionShape2D
@onready var workDialogue: CollisionShape2D = $work_dialog/trigger_work
@onready var tvDialogue: CollisionShape2D = $tv_dialog/trigger_tv

var canStand = false
var currentBoxDialogue = 1

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(184, 185, 209)
	if globals.worked:
		if !globals.watchedTV:
			tvDialogue.disabled = false
			tvTrigger.disabled = false
		newCracks.visible = true
	if globals.checkedPicture:
		pictureDialoguePreFall.disabled = true
		if !globals.worked:
			workDialogue.disabled = false
		brokenPicture.visible = true
		picture.visible = false
		pictureDialogue.disabled = true
		pictureCheckDialogue.disabled = false
	if globals.pictureFell and !globals.checkedPicture:
		brokenPicture.visible = true
		picture.visible = false
		pictureDialogue.disabled = false
		pictureDialoguePreFall.disabled = true
	if globals.boxEvent:
		boxDialogue1.disabled = true
		boxDialogue4.disabled = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact"):
		if canStand:
			canStand = false
			player.visible = true
			player.can_move = true
			player.current_dir = player.directions.RIGHT
			playerCouch.visible = false
			tvLight.enabled = false
			globals.watchedTV = true
			globals.is_dark = true
			fadeOutInteract()

func sitOnCouch():
	sitOnCouchTimer.start()

func _on_sit_on_couch_timer_timeout() -> void:
	playerCouch.visible = true
	player.can_move = false
	player.visible = false
	
	var wait = create_tween()
	wait.tween_property(watchingTvDialogue, "disabled", false, 0).set_delay(2)

func fadeToDark():
	var watch = create_tween()
	watch.set_parallel()
	watch.tween_property(tvLight, "enabled", true, 0).set_delay(4)
	watch.tween_property(ambience, "color", Color8(45, 51, 76), 0).set_delay(4)
	watch.tween_property(interactIndicator, "modulate:a", 1, 2).set_delay(8)
	watch.tween_callback(
	func canStandUp():
		interactIndicator.isUpdating = true
		canStand = true
	).set_delay(10.1)

func fadeOutInteract():
	var fadeOut = create_tween()
	fadeOut.tween_property(interactIndicator, "modulate:a", 0, 1)

func checkPic():
	player.can_move = true
	globals.checkedPicture = true
	pictureCheckDialogue.disabled = false
	workDialogue.disabled = false
	globals.canWork = true

func enableBoxDialogue():
	if currentBoxDialogue == 1:
		boxDialogue1.disabled = true
		boxDialogue2.disabled = false
		currentBoxDialogue = 2
func enableBoxDialogue2():
	if currentBoxDialogue == 2:
		boxDialogue2.disabled = true
		boxDialogue3.disabled = false
		currentBoxDialogue = 3
func enableBoxDialogue3():
	if currentBoxDialogue == 3:
		boxDialogue3.disabled = true
		boxDialogue4.disabled = false
		currentBoxDialogue = 4
		globals.boxEvent = true
