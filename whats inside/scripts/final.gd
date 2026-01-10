extends Node2D

@onready var suspenseSound: AudioStreamPlayer2D = $suspenseSound
@onready var player: CharacterBody2D = $Player
@onready var playerCam: Camera2D = $Player/playerCam
@onready var theBox: StaticBody2D = $TheBox
@onready var delay_timer: Timer = $Delay
@onready var box_timer: Timer = $BoxTimer
@onready var whiteScreen: Sprite2D = $whiteScreen
@onready var boxDialogue: CollisionShape2D = $boxDialogue/CollisionShape2D

var distance
var last_pos

var zoom_step = 0.00028
var min_zoom = 1.1
var max_zoom = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = player.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if delay_timer.is_stopped():
		delay_timer.start()
	
	#distance = player.position.distance_to(theBox.position)
	
	if player.position.x >= 200:
		if player.position.x > last_pos and playerCam.zoom < Vector2(2.0, 2.0):
			playerCam.zoom += Vector2(zoom_step, zoom_step)
		
		if player.position.x < last_pos and playerCam.zoom > Vector2(1.1, 1.1):
			playerCam.zoom -= Vector2(zoom_step, zoom_step)
	else:
		if player.position.x < last_pos and playerCam.zoom > Vector2(1.1, 1.1):
			playerCam.zoom -= Vector2(zoom_step, zoom_step)

func _on_delay_timeout() -> void:
	last_pos = player.position.x

func start_box_timer():
	box_timer.start()

func _on_box_timer_timeout() -> void:
	var box_tween = create_tween()
	box_tween.set_parallel()
	box_tween.tween_property(playerCam, "zoom", Vector2(1.3, 1.3), 10).set_ease(Tween.EASE_IN)
	box_tween.tween_property(whiteScreen, "modulate:a", 1, 5).set_delay(2.5)
	box_tween.tween_property(MainSong, "volume_db", -50, 3)
	box_tween.tween_property(suspenseSound, "playing", true, 0).set_delay(2.5)
	box_tween.tween_property(boxDialogue, "disabled", false, 0).set_delay(9)
