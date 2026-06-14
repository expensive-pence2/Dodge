extends Area2D
signal hit
signal pick

const LAYER_PLAYER = 1
const LAYER_MOBS = 2
const LAYER_BONUSES = 3

var immortality: bool = false

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	if immortality == false:
		print('врезался во врага')
		hide() # Player disappears after being hit.
		hit.emit()		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	print('взял щит')
	pick.emit()
	immortality = true
	$GetBonus.play()
	await get_tree().create_timer(3.0).timeout
	immortality = false
	$OffBonus.play()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
