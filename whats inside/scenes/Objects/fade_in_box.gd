extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	var fadeTween = create_tween()
	fadeTween.tween_property($".", "modulate:a", 0.25, 0.4)
	fadeTween.tween_property($".", "modulate:a", 0, 0.2)

func _process(_delta: float) -> void:
	if globals.inLR == true:
		globals.inLR = false
		_fadeOutBox()

func _fadeOutBox():
	var fadeTween = create_tween()
	fadeTween.tween_property($".", "modulate:a", 0.3, 0.3)
	fadeTween.tween_property($".", "modulate:a", 0, 0.2).set_delay(0.1)
