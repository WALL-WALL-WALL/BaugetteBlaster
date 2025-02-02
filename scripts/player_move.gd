extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var playerstate = "idle"
var animation_lock = false
var is_in_air = false

@export var Bullet : PackedScene = preload("res://bullet.tscn")

func _ready():   #this occurs ONCE after initialization is finished
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("bang"):
		shoot()


func _physics_process(delta: float) -> void:
	
	# Add the gravity.  (+update is_in_air)
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			playerstate = "jump"
			if not is_in_air:
				is_in_air = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerstate = "jump"
		
	
	if Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 2
		
		
	if is_on_floor() and velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		playerstate = "run"
	elif is_on_floor() and velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		playerstate = "run"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	
	if velocity.x == 0 and velocity.y == 0:
		playerstate = "idle"	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		#if $AnimatedSprite2D.get_animation() == &"impact":
		#	pass
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	playeranim()
	move_and_slide()

#refactored animation code to use global variable playerstate -S
#New System allows for hopefully better control over which anims play when -S
#from Kate: Impact animation didn't work because is_in_air was a local variable set to false each frame
#from Kate: also playeranim() occurs after previous code set state to not "jump" if on ground that frame
func playeranim():
	if animation_lock == true:
		return
	if playerstate == "idle":
		$AnimatedSprite2D.play("idle")
	elif playerstate == "run":
		$AnimatedSprite2D.play("run")
	elif playerstate == "jump":
		$AnimatedSprite2D.play("falling")
	elif playerstate == "shooting":
		$AnimatedSprite2D.play("firing")
		animation_lock = true
	
	if is_on_floor():
		if is_in_air:
			is_in_air = false
			$AnimatedSprite2D.play("impact")
			animation_lock = true

#from Kate: the AnimationLoop button was on for "impact" in SpriteFrames tab, preventing the signal from being emitted
func on_animation_finished():
	animation_lock = false


func shoot():
	const distMuzzle = 100
	if get_local_mouse_position().x < 0:            #If shot at spawn, sprite would turn if mouse was on screen's left-side instead of player's
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	$BulletSpawn.position.x = distMuzzle - distMuzzle*2 * int($AnimatedSprite2D.flip_h)
	playerstate = "shooting"
	int()
	var b = Bullet.instantiate()          #needs preload b/c "Bullet" isn't in this source
	b.position = $BulletSpawn.position
	b.set_velocity(get_local_mouse_position())
	
	add_child(b)
