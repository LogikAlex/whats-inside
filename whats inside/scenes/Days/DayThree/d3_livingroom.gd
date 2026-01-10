extends Node2D

#Box dialogues
@onready var boxDialogue1 = $box_dialog/CollisionShape2D
@onready var boxDialogue2 = $box_dialog2/CollisionShape2D
@onready var boxDialogue3 = $box_dialog3/CollisionShape2D
@onready var boxDialogue4 = $box_dialog4/CollisionShape2D

#Other objects
@onready var picture: Sprite2D = $Picture
@onready var brokenPicture: Sprite2D = $BrokenPicture

var currentBoxDialogue = 1

func _ready() -> void:
	if globals.pictureFell:
		brokenPicture.visible = true
		picture.visible = false
	if globals.boxEvent:
		boxDialogue1.disabled = true
		boxDialogue4.disabled = false

func _process(_delta: float) -> void:
	pass

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
