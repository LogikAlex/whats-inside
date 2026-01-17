extends AudioStreamPlayer2D

@export var isPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if isPlaying:
		$".".play()
	else:
		$".".stop()

func _process(_delta: float) -> void:
	if !isPlaying:
		$".".stop()
	if isPlaying:
		if !$".".playing:
			$".".stop()
			$".".play()
