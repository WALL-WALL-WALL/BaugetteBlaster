extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var playerstate = "idle"
var dying = false
var animation_lock = false
var is_in_air = false
var ready_to_shoot = true
var health = 3
var can_get_hurt = true
var can_move = true

@export var Bullet : PackedScene = preload("res://bullet.tscn")

func _ready():   #this occurs ONCE after initialization is finished
	#var connecting = get_node("../Rat")
	#if connecting:
#		connecting.attack.connect(_on_attack)
#	connecting = get_node("../Bat")
#	if connecting:
#		conne
	get_node("../")
	

		
	
func _process(_delta):
	if Input.is_action_just_pressed("bang") and ready_to_shoot == true:
		$cooldown.start()
		ready_to_shoot = false
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
	if can_move:
		if direction:
			velocity.x = direction * SPEED
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
	#elif playerstate == "shooting":
	#	$AnimatedSprite2D.play("firing")
	#	animation_lock = true
	if dying:
		$AnimatedSprite2D.play("death")
		animation_lock = true
		death()
	
	if is_on_floor():
		if is_in_air:
			is_in_air = false
			$AnimatedSprite2D.play("impact")
			animation_lock = true

#from Kate: the AnimationLoop button was on for "impact" in SpriteFrames tab, preventing the signal from being emitted
func on_animation_finished():
	animation_lock = false


func shoot():

	const distMuzzle = 40
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
	b.owned = self
	
	get_tree().get_root().add_child(b)
	b.transform = $BulletSpawn.global_transform

func _on_attack():
	if can_get_hurt:
		$AnimatedSprite2D.modulate = Color(1,0,0)
		health -= 1
		can_get_hurt = false
		$iFrames.start()
		if health <= 0:
			dying = true
			can_move = false
	
func _on_cooldown_timeout() -> void:
	ready_to_shoot = true

func death():
	$deathAnim.start()
	


func _on_death_anim_timeout() -> void:
	get_tree().call_group("enemies", "queue_free")
	var current_scene_file = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_file)


func _on_i_frames_timeout() -> void:
	can_get_hurt = true
	$AnimatedSprite2D.modulate = Color(1,1,1)
