extends Node2D

@export var playerName: String

#any day
@export var wokeUp = false
@export var brushedTeeth = false
@export var worked = false
@export var is_dark = false
@export var wantedPlayerPos: Vector2 = Vector2(24, 10)
var lastPlayerDir

#day one
@export var anotherDayDialogue = true
@export var tv_off = false
@export var coffeeDialog = false
@export var cleanedDialog = true
@export var cleanedCoffee = false

#dream
@export var wokeUpDream = false
@export var jumped = false
