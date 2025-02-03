extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal attack
var direction
@export var type = "angry"
var health = 2
var target

func _ready():
	target = get_node("../Player")

func _process(delta):
	pass


func _physics_process(delta: float) -> void:
	if target.position.x - position.x < 0:
		direction = -0.4
		$AnimatedSprite2D.flip_h = false
	else:
		direction = 0.4
		$AnimatedSprite2D.flip_h = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	animate()
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().name == "Player":
			attack.emit()
	

func animate():
	if type == "angry":
		$AnimatedSprite2D.play("angry_rat_walk")
	else:
		$AnimatedSprite2D.play("snazzy_rat_walk")

func _on_hit(body: Node2D):
	print("recieved")
	if body == self:
		health += -1
		if health <= 0:
			queue_free()
