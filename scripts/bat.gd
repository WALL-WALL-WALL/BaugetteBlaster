extends CharacterBody2D


const SPEED = 90.0
var health = 3
var direction = 1
@onready var player = 
ready_to_shoot = true

func _process(_delta):
	if ready_to_shoot == true:
		$fire.start()
		ready_to_shoot = false
		shoot()

func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = direction * SPEED
	if(direction == 1):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("default")
	

	move_and_slide()
	
func shoot():
	const distMuzzle = 100
	$BulletSpawn.position.x = distMuzzle - distMuzzle*2 * int($AnimatedSprite2D.flip_h)
	playerstate = "shooting"
	int()
	var b = Bullet.instantiate()          #needs preload b/c "Bullet" isn't in this source
	b.position = $BulletSpawn.position
	b.set_velocity((player.position - b.position).normalized())
	
	add_child(b)


func _on_flip_timeout() -> void:
	direction = direction * -1
	print("Timeout")
	print("Direction: " + direction)


func _on_fire_timeout() -> void:
	ready_to_shoot = true
