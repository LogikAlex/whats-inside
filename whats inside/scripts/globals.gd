extends Node2D

#any day
@export var wokeUp = false
@export var is_dark = false
@export var wantedPlayerPos: Vector2 = Vector2(24, 10)
var lastPlayerDir

#day one
@export var anotherDayDialogue = true
@export var tv_off = false
@export var coffeeDialog = false
@export var cleanedCoffee = false
