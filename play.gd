extends Node2D
var following: Node = null
var tile: int = 0
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_copy"):
		savelevel()
	if Input.is_action_just_pressed("ui_paste"):
		loadlevel()
	if following == null:
		for i in $tilemap.get_children():
			if i.is_in_group("player"):
				following = i
	if following != null:
		$camera.drag_vertical_enabled = true
		$camera.position = following.position
	else:
		$camera.drag_vertical_enabled = false
		$camera.position += Vector2(Input.get_axis("left", "right") * 15, Input.get_axis("up", "down") * 15)
	queue_redraw()
func savelevel() -> void:
	var arr: PackedStringArray = []
	for pos in $tilemap.get_used_cells():
		var i: int = $tilemap.get_cell_source_id(pos)
		arr.append(str(i) + "," + str(pos[0]) + "," + str(pos[1]))
	var file: FileAccess = FileAccess.open("user://level.txt", FileAccess.WRITE)
	file.store_string("/".join(arr))
func loadlevel() -> void:
	$tilemap.clear()
	var file: FileAccess = FileAccess.open("user://level.txt", FileAccess.READ)
	var strr: String = file.get_as_text()
	var arr: PackedStringArray = strr.split("/")
	for i in arr:
		var ind: int = int(i.get_slice(",", 0))
		var pos: Vector2i = Vector2i(int(i.get_slice(",", 1)), int(i.get_slice(",", 2)))
		if ind == 0:
			$tilemap.set_cells_terrain_connect([pos], 0, 0)
		else:
			$tilemap.set_cell(pos, ind, Vector2i(0, 0))
	following = null
func _draw() -> void:
	if Input.is_key_label_pressed(KEY_1):
		tile = 0
	if Input.is_key_label_pressed(KEY_2):
		tile = 1
	if Input.is_key_label_pressed(KEY_3):
		tile = 2
	var mp = Vector2i(floor(get_global_mouse_position().x / 32) * 32, floor(get_global_mouse_position().y / 32) * 32)
	var rect = Rect2(mp.x, mp.y, 32, 32)
	draw_rect(rect, Color.from_string("#7535FF", Color.REBECCA_PURPLE))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tile == 0:
			$tilemap.set_cells_terrain_connect([mp / 32], tile, 0)
		else:
			$tilemap.set_cell(mp / 32, tile, Vector2i(0, 0))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$tilemap.set_cells_terrain_connect([mp / 32], 0, -1, false)
