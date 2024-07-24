extends Camera3D

var rot_x = 0
var rot_y = 0

const SENSITIVITY = 0.005

func _ready():
	rot_x = rotation.y # почему
	rot_y = rotation.x # тут такой же вопрос

func _input(event):
	if event is InputEventMouseMotion and event.button_mask & 1:
		rot_x += event.relative.x * SENSITIVITY
		rot_y += event.relative.y * SENSITIVITY

		rot_y = clamp(rot_y, -PI/2, PI/2)

		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), rot_x)
		rotate_object_local(Vector3(1, 0, 0), rot_y)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov += 3
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov -= 3

		fov = clamp(fov, 20, 90)
		
