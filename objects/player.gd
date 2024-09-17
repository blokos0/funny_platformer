extends CharacterBody2D
var accel: int = 50
var maxspeed: int = 500
var bouncepower: float = -400
var gravity: int = 15
var bounced: bool = false
var lastdir: float = 1
var velocityxconserved: float
var boosttimer: int
var boostcount: int
func _physics_process(_delta: float) -> void:
	var dir: float = Input.get_axis("left", "right")
	if dir != 0:
		lastdir = dir
	velocity.y += gravity
	if Input.is_action_just_pressed("down") && velocity.y < 500:
		velocity.y = 500
		velocity.x = (abs(velocity.x) + 800) * dir
		print("funny groundpound thing! velocity.x does THings")
	if Input.is_action_just_pressed("up") && !boosttimer && !is_on_floor() && boostcount < 3:
		velocity.y = -500 + boostcount * 100
		velocity.x = (abs(velocity.x) + 900 + boostcount * 250) * dir
		boostcount += 1
		boosttimer = 25
		$particles.emitting = true
		print("funny boost thing! velocity.x does THings")
	boosttimer = max(boosttimer - 1, 0)
	if !boosttimer || velocity.y > 0:
		$particles.emitting = false
	if is_on_floor() && !has_node("safetyplatform"):
		queue_free() #global.restart()
	if is_on_wall(): # is_on_wall() only detects collisions if im moving into a wall (sometimes???), which is bad and must be fixed
		if !Input.is_action_pressed("down"):
			var colpos: Vector2 = get_last_slide_collision().get_position()
			var tilepos: Vector2i = get_parent().local_to_map(Vector2(colpos.x - max(get_wall_normal()[0], 0), colpos.y)) # spaghetti
			var tiledata: TileData = get_parent().get_cell_tile_data(tilepos)
			var slip: bool = true
			if tiledata:
				slip = tiledata.get_custom_data("slippery")
			if !slip:
				bounce(bouncepower)
				if dir == get_wall_normal()[0]:
					velocity.x += velocityxconserved * -1
					print("wallbounce! velocity.x mirrored")
	else:
		bounced = false
		velocityxconserved = velocity.x
	if dir && has_node("safetyplatform"):
		$safetyplatform.free()
	velocity.x = move_toward(velocity.x, maxspeed * dir, accel)
	move_and_slide()
func bounce(powa: float) -> void:
	if bounced:
		return
	velocity.y = powa - max(abs(velocity.x) - maxspeed, 0) / 4
	bounced = true
	boosttimer = 0
	boostcount = 0
