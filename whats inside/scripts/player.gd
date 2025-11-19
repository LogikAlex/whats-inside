extends CharacterBody2D

@export var speed: float = 50.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactHitbox: Area2D = $InteractHitbox

var direction: Vector2
var current_dir
var state: playerState

var canMove = true

enum directions {DOWN, UP, RIGHT, LEFT}
enum playerState {IDLE, WALKING, INTERACTING}

func _physics_process(_delta: float) -> void:
	if state == playerState.INTERACTING:
		canMove = false
	
	if canMove:
		direction = (Input.get_vector("move_left", "move_right", "move_up", "move_down")).normalized()
		velocity = direction * speed
	
	play_anim()
	interact_orientation()
	move_and_slide()

func play_anim():
	if direction:
		if direction.x > 0:
			if direction.y > 0:
				sprite.play("front_walk")
				current_dir = directions.DOWN
			elif direction.y < 0:
				sprite.play("up_walk")
				current_dir = directions.UP
			else:
				sprite.play("right_walk")
				current_dir = directions.RIGHT
		elif direction.x < 0:
			if direction.y > 0:
				sprite.play("front_walk")
				current_dir = directions.DOWN
			elif direction.y < 0:
				sprite.play("up_walk")
				current_dir = directions.UP
			else:
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

func interact_orientation():
	if current_dir == directions.DOWN:
		interactHitbox.rotation_degrees = 0
	elif current_dir == directions.UP:
		interactHitbox.rotation_degrees = 180
	elif current_dir == directions.RIGHT:
		interactHitbox.rotation_degrees = -90
	elif current_dir == directions.LEFT:
		interactHitbox.rotation_degrees = 90
