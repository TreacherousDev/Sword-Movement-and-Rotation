extends Sprite2D

var rotating = false
var orientation = "right"
var delay = 0.15
@onready var sword_size : int = texture.get_width()

func _ready():
	offset.x = sword_size / 2

func _process(_delta):
	if !rotating:
		check_input()


func check_input():
	if Input.is_action_just_pressed("right"):
		rotate_sword(180, 0, false, "right")
	elif Input.is_action_just_pressed("down"):
		rotate_sword(270, 90, false, "down")
	elif Input.is_action_just_pressed("left"):
		rotate_sword(0, 180, false, "left")
	elif Input.is_action_just_pressed("up"):
		rotate_sword(90, 270, false, "up")

	elif Input.is_action_just_pressed("ui_right"):
		rotate_sword(180, 0, true, "right")
	elif Input.is_action_just_pressed("ui_down"):
		rotate_sword(270, 90, true, "down")
	elif Input.is_action_just_pressed("ui_left"):
		rotate_sword(0, 180, true, "left")
	elif Input.is_action_just_pressed("ui_up"):
		rotate_sword(90, 270, true, "up")
		
	


func rotate_sword(to_rotation_if_same: int, to_rotation_if_different: int, clockwise: bool, to_orientation: String):
	var target_rotation = to_rotation_if_same if (to_orientation == orientation) else to_rotation_if_different

	#add / subtract 1 full rotation so interpolation happens in the proper direction
	#ex: 270 to 90 clockwise will be 270 to 450, since negatively incrementing will be ccw rotation
	#rotation will be wrapped back to 0-360 on the next rotation call
	if clockwise == true:
		rotation_degrees -= 360 if (rotation_degrees > target_rotation) else 0
	elif clockwise == false:
		rotation_degrees += 360 if (rotation_degrees < target_rotation) else 0
	
	var move_direction := Vector2.ZERO
	var move: bool = to_orientation == orientation

	if to_orientation == orientation:
		match(orientation):
			"right":
				move_direction = Vector2.RIGHT * sword_size
				to_orientation = "left"
			"down":
				move_direction = Vector2.DOWN * sword_size
				to_orientation = "up"
			"left":
				move_direction = Vector2.LEFT * sword_size
				to_orientation = "right"
			"up":
				move_direction = Vector2.UP * sword_size
				to_orientation = "down"

	handle_rotation(target_rotation, move_direction, to_orientation, move)

func handle_rotation(target_rotation: int, position_value: Vector2, orientation_value: String, move: bool):
	rotating = true
	
	if move == true:
		offset.x = -(sword_size / 2)
		global_position += position_value

	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation, delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	if move == true:
		offset.x = (sword_size / 2)
		global_position += position_value

	orientation = orientation_value
	rotating = false
