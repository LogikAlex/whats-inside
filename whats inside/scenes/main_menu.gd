extends Node2D

@onready var startSound: AudioStreamPlayer2D = $startSound
@onready var selectSound: AudioStreamPlayer2D = $selectSound

@onready var camera: Camera2D = $Camera2D

@onready var blackScreen: Sprite2D = $BlackScreen
@onready var selectionText: Sprite2D = $StartText
@onready var selectionArrowStart: Sprite2D = $SelectionArrowStart
@onready var selectionArrowExit: Sprite2D = $SelectionArrowExit
@onready var titleScreen: Sprite2D = $TitleScreen
@onready var titleScreenBox: Sprite2D = $TheBoxTitleScreen

@onready var startArea: CollisionShape2D = $selectionAreaStart/CollisionShape2D
@onready var exitArea: CollisionShape2D = $selectionAreaExit/CollisionShape2D

enum selection {start, exit, started}

var current_selection
var changed_state = false

var canClick = false

func _ready() -> void:
	resetGlobals()
	fadeOutBs()
	selectionArrowExit.visible = false
	selectionArrowStart.visible = false
	current_selection = selection.start

func _process(_delta: float) -> void:
	handleSelection()
	mouseSelection()
	keyboardSelection()

func resetGlobals():
	globals.lastRandLetterFrame = -1
	globals.wokeUp = false
	globals.brushedTeeth = false
	globals.worked = false
	globals.is_dark = false
	globals.wantedPlayerPos = Vector2(24, 10)
	globals.anotherDayDialogue = true
	globals.tv_off = true
	globals.coffeeDialog = false
	globals.cleanedDialog = true
	globals.cleanedCoffee = false

	#dream
	globals.wokeUpDream = false
	globals.jumped = false

	#day three
	globals.canWork = false
	globals.wokeFromDream = false
	globals.inLR = false
	globals.pictureFell = false
	globals.checkedPicture = false
	globals.checkedCoffee = false
	globals.boxEvent = false
	globals.watchedTV = false

	#day four
	globals.wokeD4 = false
	globals.checkedAll = false
	globals.bedroomBlame = true
	globals.balconyBlame = true
	globals.livingroomBlame = true
	globals.entryBlame = true
	globals.bathroomBlame = true
	globals.kitchenBlame = true

	#tweak sequence
	globals.current_dial = 1

	#final day
	globals.finalBedroomFade = false

func fadeOutBs():
	var bsTween = create_tween()
	bsTween.tween_property(blackScreen, "modulate:a", 0, 2).set_delay(1)

func keyboardSelection():
	if Input.is_action_just_pressed("interact"):
		if current_selection == selection.start:
			start()
		if current_selection == selection.exit:
			get_tree().quit()

func mouseSelection():
	if Input.is_action_just_pressed("click"):
		if current_selection == selection.start:
			if canClick:
				canClick = false
				start()
		if current_selection == selection.exit:
			if canClick:
				canClick = false
				get_tree().quit()

func start():
	current_selection = selection.started
	cam_shake()
	startSound.play()
	selectionArrowStart.canPulse = false
	selectionArrowExit.canPulse = false
	startArea.disabled = true
	exitArea.disabled = true
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(selectionArrowStart, "modulate:a", 0, 0.2)
	tween.tween_property(selectionArrowExit, "modulate:a", 0, 0.2)
	tween.tween_property(selectionText, "modulate:a", 0, 1)
	tween.tween_property(titleScreen, "position", Vector2(159.28, 84.8), 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(1)
	tween.tween_property(titleScreenBox, "position", Vector2(266.28, 89.8), 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(1)
	tween.tween_property(titleScreen, "modulate:a", 0, 3).set_delay(7)
	tween.tween_property(titleScreenBox, "modulate:a", 0, 3).set_delay(7)
	tween.tween_callback(
	func finish():
		current_selection = selection.started
	).set_delay(0.05)
	tween.tween_callback(
	func finish():
		selectionArrowStart.visible = false
	).set_delay(0.2)
	tween.tween_callback(
	func finish():
		get_tree().change_scene_to_file("res://scenes/MainMenu/hint_scene.tscn")
	).set_delay(11)

func handleSelection():
	if current_selection != selection.started:
		if current_selection == selection.start:
			selectionArrowStart.visible = true
		else:
			selectionArrowStart.visible = false
		
		if current_selection == selection.exit:
			selectionArrowExit.visible = true
		else:
			selectionArrowExit.visible = false
		
		if Input.is_action_just_pressed("ui_down"):
			if current_selection == selection.start:
				selectSound.play()
				current_selection = selection.exit
		
		if Input.is_action_just_pressed("ui_up"):
			if current_selection == selection.exit:
				selectSound.play()
				current_selection = selection.start


func cam_shake():
	var shake_tween = create_tween()
	shake_tween.tween_property(camera, "offset", Vector2(2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(-2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(0, 0), 0.09)


func _on_selection_area_start_mouse_entered() -> void:
	if current_selection != selection.start:
		selectSound.play()
	current_selection = selection.start
	canClick = true


func _on_selection_area_start_mouse_exited() -> void:
	current_selection = selection.start
	canClick = false


func _on_selection_area_exit_mouse_entered() -> void:
	if current_selection != selection.started:
		if current_selection != selection.exit:
			selectSound.play()
		current_selection = selection.exit
		canClick = true


func _on_selection_area_exit_mouse_exited() -> void:
	current_selection = selection.exit
	canClick = false
