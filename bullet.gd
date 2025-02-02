extends Area2D

signal hit()

const SPEED = 1100
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func set_velocity(mouse):
	velocity.x = mouse.x - position.x
	velocity.y = mouse.y - position.y
	velocity = velocity.normalized() * SPEED

func _on_body_entered(body: Node2D) -> void:
	if body != CharacterBody2D:
		if body == TileMapLayer:
			queue_free()
		else:
		#if body.is_in_group("mobs")
			hit.emit()
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
