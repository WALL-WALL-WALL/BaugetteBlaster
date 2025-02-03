extends CharacterBody2D

var health = 1
var dead = false

func _on_hit(body: Node2D):
	#print("recieved")
	if body == self:
		health += -1
		if health <= 0:
			$AnimatedSprite2D.play("death")
			dead = true

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("idle")


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	if dead == false:
		$AnimatedSprite2D.play("appear")
		$Timer.start()


func _on_animated_sprite_2d_animation_finished() -> void:
	if dead == true:
		$AnimatedSprite2D.play("ded")
		$CollisionShape2D.disabled = true
