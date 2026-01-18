extends Sprite2D

@export var canPulse = true

var tween: Tween = create_tween()

var changed = false

func _ready() -> void:
	if canPulse:
		alphaPulse()

func _process(_delta: float) -> void:
	if !canPulse and !changed:
		changed = true
		tween.kill()
		$".".modulate.a = 1

func alphaPulse():
	tween.set_loops()
	tween.tween_property($".", "modulate:a", 0.1, 0.5)
	tween.tween_property($".", "modulate:a", 0.8, 0.5)
