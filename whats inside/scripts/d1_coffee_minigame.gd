extends Node2D

var idle_cursor = load("res://assets/misc/cursor1.png")
var grab_cursor = load("res://assets/misc/cursor2.png")
var isIn = false
var cleaning = false
var last_pos: Vector2
var finished = false

@onready var cloth = $Cloth
@onready var cloth_sprite = $Cloth/Cloth
@onready var spilled_coffee = $SpilledCoffee/spilledcoffee
@onready var delay_timer = $delay
@onready var black_screen = $BlackScreen/Sprite2D

func _ready() -> void:
	MainSong.isPlaying = true
	Input.set_custom_mouse_cursor(idle_cursor, Input.CURSOR_ARROW, Vector2(8, 8))

func _process(delta: float) -> void:
	if delay_timer.is_stopped():
		delay_timer.start()
	
	if cleaning and spilled_coffee.modulate.a != 0:
		if (cloth.position != last_pos):
			spilled_coffee.modulate.a -= 0.21 * delta
	
	if spilled_coffee.modulate.a <= 0 and !finished:
		finished = true
		_on_finished()
	
	if Input.is_action_pressed("click"):
		Input.set_custom_mouse_cursor(grab_cursor, Input.CURSOR_ARROW, Vector2(8, 8))
		if isIn:
			cloth.position = get_global_mouse_position()
			cloth_sprite.frame = 0
	else:
		Input.set_custom_mouse_cursor(idle_cursor, Input.CURSOR_ARROW, Vector2(8, 8))
		if isIn:
			cloth_sprite.frame = 1

func _on_cloth_mouse_entered() -> void:
	isIn = true
	cloth_sprite.frame = 1

func _on_cloth_mouse_exited() -> void:
	isIn = false
	cloth_sprite.frame = 0

func _on_spilled_coffee_area_entered(area: Area2D) -> void:
	if area.is_in_group("cloth"):
		cleaning = true

func _on_spilled_coffee_area_exited(area: Area2D) -> void:
	if area.is_in_group("cloth"):
		cleaning = false

func _on_delay_timeout() -> void:
	last_pos = cloth.position

func _on_finished():
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 1, 2)
	tween.tween_callback(
	func _finish():
		globals.cleanedCoffee = true
		Input.set_custom_mouse_cursor(null)
		$".".free()
	).set_delay(2.1)
