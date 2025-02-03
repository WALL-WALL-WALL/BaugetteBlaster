extends CharacterBody2D


const SPEED = 200.0
var direction = 1
var flipped = false
var health = 2


func _process(_delta):
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	$AnimatedSprite2D.play("default")
	if flipped == false:
		flipped = true
		$flip.start()
	move_and_slide()
	

func _on_flip_timeout() -> void:
	direction = direction * -1
	flipped = false


func _on_hit(body: Node2D):
	if body == self:
		health -= 1
		if health <= 0:
			queue_free()
