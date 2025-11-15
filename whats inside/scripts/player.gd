extends CharacterBody2D

@export var speed: float = 50.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2
var current_dir
var state: playerState

var canMove = true

enum directions {DOWN, UP, RIGHT, LEFT}
enum playerState {IDLE, WALKING, INTERACTING}

func _physics_process(_delta: float) -> void:
	direction = (Input.get_vector("move_left", "move_right", "move_up", "move_down")).normalized()
	if canMove:
		velocity = direction * speed
	
	play_anim()
	move_and_slide()

func play_anim():
	if direction:
		if direction.x > 0:
			sprite.play("right_walk")
			current_dir = directions.RIGHT
		elif direction.x < 0:
			sprite.play("left_walk")
			current_dir = directions.LEFT
		elif direction.y > 0:
			sprite.play("front_walk")
			current_dir = directions.DOWN
		elif direction.y < 0:
			sprite.play("up_walk")
			current_dir = directions.UP
	else:
		if current_dir == directions.DOWN:
			sprite.play("front_idle")
		elif current_dir == directions.UP:
			sprite.play("up_idle")
		elif current_dir == directions.RIGHT:
			sprite.play("right_idle")
		elif current_dir == directions.LEFT:
			sprite.play("left_idle")
