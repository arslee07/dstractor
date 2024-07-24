extends VehicleBody3D

@export var left: Array[VehicleWheel3D]
@export var right: Array[VehicleWheel3D]

var defaultTransform = transform

var dir_to_force = { 
	Vector2(0, 0): Vector2(0, 0),
	Vector2(0, 1): Vector2(40, 40), # W
	Vector2(-1, 0): Vector2(-40, 40), # A
	Vector2(0, -1): Vector2(-40, -40), # S
	Vector2(1, 0): Vector2(40, -40), # D
	Vector2(-1, 1): Vector2(-20, 40), # WA
	Vector2(1, 1): Vector2(40, -20), # WD
	Vector2(-1, -1): Vector2(20, -40), # SA
	Vector2(1, -1): Vector2(-40, 20), # SD
}

func _physics_process(delta):
	if Input.is_action_just_pressed("reset"):
		transform = defaultTransform

	var dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("back", "forward"),
	)

	var force = dir_to_force[dir]
	var left_force = force.x
	var right_force = force.y

	for wh in left:
		wh.engine_force = left_force
	for wh in right:
		wh.engine_force = right_force

