extends Sprite2D

var rotating = false
var orientation = "right"


func _process(_delta):

	var clockwise = false if Input.is_key_pressed(KEY_SPACE) else true

	if !rotating:
		if Input.is_action_just_pressed("right"):
			rotate_sword(180, 0, clockwise, "right")

		elif Input.is_action_just_pressed("down"):
			rotate_sword(270, 90, clockwise, "down")

		elif Input.is_action_just_pressed("left"):
			rotate_sword(0, 180, clockwise, "left")

		elif Input.is_action_just_pressed("up"):
			rotate_sword(90, 270, clockwise, "up")


func rotate_sword(rotation_if_same: int, rotation_if_different: int, clockwise: bool, to_orientation: String):
	rotation_degrees = wrapf(rotation_degrees, 0, 360)
	
	var rotation_value = rotation_if_same if (to_orientation == orientation) else rotation_if_different

	if clockwise == true:
		rotation_value += 360 if (rotation_degrees > rotation_value) else 0
	elif clockwise == false:
		rotation_value -= 360 if (rotation_degrees < rotation_value) else 0

	var target_rotation = rotation_degrees + rotation_value - (int(rotation_degrees) % 360)

	if to_orientation == orientation:
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
		handle_rotation(target_rotation, Vector2.ZERO, to_orientation, 0)

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
