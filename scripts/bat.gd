extends CharacterBody2D

@export var Bullet : PackedScene = preload("res://bullet.tscn")

signal attack
const SPEED = 200.0
var target
var direction
var direction2 = -1
var health = 1


func _ready():
	target = get_node("../Player")
	$flip.start()
	$fire.start()

func _physics_process(delta: float) -> void:
	if abs(target.position.x - position.x) < 400:
		direction = 1
	elif abs(target.position.x - position.x) > 500:
		direction = -1
	else:
		direction = 0
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction2:
		velocity.y = direction2 * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	$AnimatedSprite2D.play("default")
		
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().name == "Player":
			target._on_attack()
	

func _on_flip_timeout() -> void:
	direction2 *= -1

func _on_hit(body: Node2D):
	if body == self:
		health -= 1
		if health <= 0:
			queue_free()

func _on_fire_timeout() -> void:
	var target = get_node("../Player")
	var b = Bullet.instantiate()          #needs preload b/c "Bullet" isn't in this source
	b.position = $BulletSpawn.position
	b.set_velocity((target.position - position)/2)
	b.owned = self
	print(b.owned)
	
	get_tree().get_root().add_child(b)
	b.transform = $BulletSpawn.global_transform
