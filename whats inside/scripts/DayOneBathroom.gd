extends Node2D

@onready var ambience = $ambience
@onready var teethBrush = $sink_func/CollisionShape2D
@onready var mirrorDialogue = $mirror_dialog/CollisionShape2D
@onready var brushRemind = $brushDialogue/CollisionShape2D

func _ready() -> void:
	if globals.brushedTeeth:
		teethBrush.disabled = true
		mirrorDialogue.disabled = false
		brushRemind.disabled = true
	else:
		brushRemind.disabled = false
		teethBrush.disabled = false
		mirrorDialogue.disabled = true
	
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(202, 208, 229)

func _sink():
	globals.brushedTeeth = true
	$Stand.get_node("Sprite2D").frame = 1
	$sink_sound.play()
	$sinkTimer.start()

func _on_sink_timer_timeout() -> void:
	$Player.can_move = true
	$Stand.get_node("Sprite2D").frame = 0
	mirrorDialogue.disabled = false
