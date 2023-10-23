extends Sprite2D

var rotating = false
var orientation = "right"


func _process(_delta):
	var clockwise = true
	
	if Input.is_key_pressed(KEY_SHIFT):
		clockwise = false

	if !rotating:
		if Input.is_action_just_pressed("ui_right"):
			rotate_sword(180, 0, clockwise, "right")

		if Input.is_action_just_pressed("ui_down"):
			rotate_sword(270, 90, clockwise, "down")

		if Input.is_action_just_pressed("ui_left"):
			rotate_sword(0, 180, clockwise, "left")

		if Input.is_action_just_pressed("ui_up"):
			rotate_sword(90, 270, clockwise, "up")


func rotate_sword(rotation_if_same: int, rotation_if_different: int, _clockwise: bool, _orientation: String):
	rotation_degrees = wrapf(rotation_degrees, 0, 360)
	
	var rotation_value = rotation_if_same if (_orientation == orientation) else rotation_if_different

	if _clockwise == true:
		rotation_value += 360 if (rotation_degrees > rotation_value) else 0
	elif _clockwise == false:
		rotation_value -= 360 if (rotation_degrees < rotation_value) else 0

	var target_rotation = rotation_degrees + rotation_value - (int(rotation_degrees) % 360)

	if _orientation == orientation:
		match(orientation):
			"right":
				handle_rotation(target_rotation, Vector2(800, 0), "left", 1)
			"down":
				handle_rotation(target_rotation, Vector2(0, 800), "up", 1)
			"left":
				handle_rotation(target_rotation, Vector2(-800, 0), "right", 1)
			"up":
				handle_rotation(target_rotation, Vector2(0, -800), "down", 1)
	else:
		handle_rotation(target_rotation, Vector2(0, 0), _orientation, 0)

func handle_rotation(target_rotation: int, position_value: Vector2, orientation_value: String, move: bool):
	var delay = 0.3
	rotating = true
	
	if move == true:
		offset.x = -400
		global_position += position_value

	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation, delay).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(delay).timeout
	
	if move == true:
		offset.x = 400
		global_position += position_value

	orientation = orientation_value
	rotating = false
