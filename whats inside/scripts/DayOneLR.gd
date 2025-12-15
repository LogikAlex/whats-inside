extends Node2D

@onready var ambience = $ambience
@onready var player_couch = $Player_on_couch
@onready var player = $Player
@onready var couch_timer = $CouchTimer
@onready var end_couch_timer = $EndCouchTimer
@onready var couch_end_dialogue = $couch_end/trigger_end_couch
@onready var tv_light = $tvLight
@onready var watch_tv_trigger = $tv_watch/trigger_watch_tv
@onready var sleep_trigger = $should_sleep/trigger_sleep

#cad0e5
#x - 109,  y - 25
func _start_couch_timer():
	couch_timer.start()
	player.can_move = false

func _watch_tv():
	player_couch.visible = true
	player.visible = false
	_fade_to_dark()

func _end_tv():
	player.position = Vector2(109, 25)
	player.current_dir = player.directions.RIGHT
	sleep_trigger.disabled = false
	end_couch_timer.start()

func _fade_to_dark():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(tv_light, "enabled", true, 0).set_delay(1.5)
	tween.tween_property(ambience, "color", Color8(45, 51, 76), 8).set_delay(5)
	tween.tween_callback(func enable_the_big_d(): couch_end_dialogue.disabled = false).set_delay(15.5)

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
		watch_tv_trigger.disabled = true
		sleep_trigger.disabled = false
	else:
		ambience.color = Color8(202, 208, 229)
	if globals.tv_off:
		$tv_turn_off.free()
		$tv_left_on.free()
	if globals.workedD1:
		watch_tv_trigger.disabled = false

func _process(_delta: float) -> void:
	if globals.is_dark:
		watch_tv_trigger.disabled = true

func _on_couch_timer_timeout() -> void:
	_watch_tv()

func _on_end_couch_timer_timeout() -> void:
	globals.is_dark = true
	player_couch.visible = false
	tv_light.enabled = false
	player.visible = true
	player.can_move = true
