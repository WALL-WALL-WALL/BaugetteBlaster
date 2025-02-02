extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playerstate = "idle"
var animation_lock = false
@export var Bullet : PackedScene = preload("res://bullet.tscn")

func _ready():
	if $AnimatedSprite2D.animation_finished:
		on_animation_finished()
	
func _process(_delta):
	if Input.is_action_just_pressed("bang"):
		shoot()

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			playerstate = "jump"

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	playeranim()
	move_and_slide()

#refactored animation code to use global variable playerstate -S
#New System allows for hopefully better control over which anims play when -S
func playeranim():
	if animation_lock == true:
		return
		
	var is_in_air = false
	
	if playerstate == "idle":
		$AnimatedSprite2D.play("idle")
	elif playerstate == "run":
		$AnimatedSprite2D.play("run")
	elif playerstate == "jump":
		$AnimatedSprite2D.play("falling")
		if is_on_floor():
			if (is_in_air == true):
				is_in_air = false
				$AnimatedSprite2D.play("impact")
				animation_lock = true
		else:
			is_in_air = true
			
func on_animation_finished():
	animation_lock = false

func shoot():
	#(make player stop and/or turn toward mouse when shooting?)
	if get_viewport().get_mouse_position().x < get_viewport().size.x/2:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	$BulletSpawn.position.x = 100 - 200 * int($AnimatedSprite2D.flip_h)
	int()
	var b = Bullet.instantiate()
	b.position = $BulletSpawn.position
	var mouse = get_local_mouse_position()
	b.set_velocity(mouse)
	
	add_child(b)
