extends Sprite2D

var frameNum
var chosen = false

func _ready() -> void:
	frameNum = randi_range(1, 7)
	frame = frameNum
	if frameNum == globals.lastRandLetterFrame:
		frameNum = randi_range(1, 7)
		frame = frameNum
	else:
		globals.lastRandLetterFrame = frameNum
