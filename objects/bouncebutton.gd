extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var powa = body.bouncepower
		if Input.is_action_pressed("down"):
			powa *= 1.45
		body.bounce(powa)
		body.velocity.x *= 1.5
		print("button bounce! velocity.x multiplied by 1.5")
		$sprite.frame = 1
func _on_body_exited(_body: Node2D) -> void:
	$sprite.frame = 0
