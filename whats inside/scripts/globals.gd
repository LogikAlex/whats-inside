extends Node2D

@export var playerName: String

#any day
@export var lastRandLetterFrame: int = -1
@export var wokeUp = false
@export var brushedTeeth = false
@export var worked = false
@export var is_dark = false
@export var wantedPlayerPos: Vector2 = Vector2(24, 10)
var lastPlayerDir

#day one
@export var anotherDayDialogue = true
@export var tv_off = true
@export var coffeeDialog = false
@export var cleanedDialog = true
@export var cleanedCoffee = false

#day three
@export var canWork = false
@export var wokeFromDream = false
@export var inLR = false
@export var pictureFell = false
@export var checkedPicture = false
@export var checkedCoffee = false
@export var boxEvent = false

#dream
@export var wokeUpDream = false
@export var jumped = false
