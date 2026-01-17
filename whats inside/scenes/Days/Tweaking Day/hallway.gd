extends Node2D

@onready var player: CharacterBody2D = $Player

func play_music():
	NightSong.stop()
	TweakingSong.play()
	player.can_move = true
