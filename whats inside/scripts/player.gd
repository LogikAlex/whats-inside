extends CharacterBody2D

@export var speed: float = 45.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactHitbox: Area2D = $InteractHitbox
@onready var interactIndicator: Sprite2D = $InteractIndicator

var direction: Vector2
var current_dir
var state: playerState

var can_move: bool = true

enum directions {DOWN, UP, RIGHT, LEFT}
enum playerState {IDLE, WALKING}

func _ready() -> void:
	position = globals.wantedPlayerPos
	current_dir = globals.lastPlayerDir
	$Camera2D/BlackScreen/Sprite2D.visible = true
	$Camera2D/BlackScreen/Sprite2D.modulate.a = 1
	var blackTween = create_tween()
	blackTween.tween_property($Camera2D/BlackScreen/Sprite2D, "modulate:a", 0, 0.5).set_delay(0.25)

func _physics_process(_delta: float) -> void:
	if can_move:
		direction = (Input.get_vector("move_left", "move_right", "move_up", "move_down")).normalized()
		velocity = direction * speed
		play_anim()
		interact_orientation()
		move_and_slide()
	else:
		play_idle_anim()

func play_anim():
	if direction:
		if direction.x > 0:
			if direction.y > 0:
				sprite.play("front_walk")
				current_dir = directions.DOWN
				globals.lastPlayerDir = directions.DOWN
			elif direction.y < 0:
				sprite.play("up_walk")
				current_dir = directions.UP
				globals.lastPlayerDir = directions.UP
			else:
				sprite.play("right_walk")
				current_dir = directions.RIGHT
				globals.lastPlayerDir = directions.RIGHT
		elif direction.x < 0:
			if direction.y > 0:
				sprite.play("front_walk")
				current_dir = directions.DOWN
				globals.lastPlayerDir = directions.DOWN
			elif direction.y < 0:
				sprite.play("up_walk")
				current_dir = directions.UP
				globals.lastPlayerDir = directions.UP
			else:
				sprite.play("left_walk")
				current_dir = directions.LEFT
				globals.lastPlayerDir = directions.LEFT
		elif direction.y > 0:
			sprite.play("front_walk")
			current_dir = directions.DOWN
			globals.lastPlayerDir = directions.DOWN
		elif direction.y < 0:
			sprite.play("up_walk")
			current_dir = directions.UP
			globals.lastPlayerDir = directions.UP
	else:
		play_idle_anim()

func interact_orientation():
	if current_dir == directions.DOWN:
		interactHitbox.rotation_degrees = 0
	elif current_dir == directions.UP:
		interactHitbox.rotation_degrees = 180
	elif current_dir == directions.RIGHT:
		interactHitbox.rotation_degrees = -90
	elif current_dir == directions.LEFT:
		interactHitbox.rotation_degrees = 90

func play_idle_anim():
	if current_dir == directions.DOWN:
		sprite.play("front_idle")
	elif current_dir == directions.UP:
		sprite.play("up_idle")
	elif current_dir == directions.RIGHT:
		sprite.play("right_idle")
	elif current_dir == directions.LEFT:
		sprite.play("left_idle")

func interact_indicator_appear():
	var tween: Tween = create_tween()
	tween.tween_property(interactIndicator, "modulate:a", 1, 0.2)

func interact_indicator_disappear():
	var tween: Tween = create_tween()
	tween.tween_property(interactIndicator, "modulate:a", 0, 0.2)

func can_walk():
	can_move = true
