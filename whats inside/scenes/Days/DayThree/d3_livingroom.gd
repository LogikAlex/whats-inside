extends Node2D

#Box dialogues
@onready var boxDialogue1 = $box_dialog/CollisionShape2D
@onready var boxDialogue2 = $box_dialog2/CollisionShape2D
@onready var boxDialogue3 = $box_dialog3/CollisionShape2D
@onready var boxDialogue4 = $box_dialog4/CollisionShape2D

#Other objects
@onready var player: CharacterBody2D = $Player
@onready var picture: Sprite2D = $Picture
@onready var brokenPicture: Sprite2D = $BrokenPicture
@onready var pictureDialogue: CollisionShape2D = $picture_dialog/CollisionShape2D
@onready var pictureCheckDialogue: CollisionShape2D = $picture_check/CollisionShape2D

var currentBoxDialogue = 1

func _ready() -> void:
	if globals.checkedPicture:
		brokenPicture.visible = true
		picture.visible = false
		pictureDialogue.disabled = true
		pictureCheckDialogue.disabled = false
	if globals.pictureFell and !globals.checkedPicture:
		brokenPicture.visible = true
		picture.visible = false
		pictureDialogue.disabled = false
	if globals.boxEvent:
		boxDialogue1.disabled = true
		boxDialogue4.disabled = false

func _process(_delta: float) -> void:
	pass

func checkPic():
	player.can_move = true
	globals.checkedPicture = true
	pictureCheckDialogue.disabled = false

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
