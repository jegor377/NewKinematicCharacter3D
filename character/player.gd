extends KinematicCharacter


export(float) var speed = 50
export(float) var speed_change_rate = 15

export(float, 0.1, 1.0) var mouse_sensivitiy = 0.3
export(float, -90, 0) var min_pitch = -90
export(float, 0, 90) var max_pitch = 45

var forward := false
var backward := false
var left := false
var right := false

onready var camera_pivot := $CameraPivot
onready var camera := $CameraPivot/CameraBoom/Camera


func _manipulate_velocities(delta: float) -> void:
	var dir := Vector3.ZERO
	if forward:
		dir -= transform.basis.z
	if backward:
		dir += transform.basis.z
	if left:
		dir -= transform.basis.x
	if right:
		dir += transform.basis.x
	static_velocity = static_velocity.linear_interpolate(dir.normalized() * speed, speed_change_rate * delta)
	if static_velocity.length() < 0.5:
		static_velocity = Vector3.ZERO

func _handle_collision(collision: KinematicCollision, delta: float) -> void:
	if collision.collider.is_in_group('Bouncer'):
		apply_impulse(collision.normal * speed)
	if collision.collider.is_in_group('Bouncer2'):
		bounce(collision.normal * 20)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensivitiy
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensivitiy
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)
	if event.is_action_pressed("forward"):
		forward = true
	elif event.is_action_released("forward"):
		forward = false
	if event.is_action_pressed("backward"):
		backward = true
	elif event.is_action_released("backward"):
		backward = false
	if event.is_action_pressed("left"):
		left = true
	elif event.is_action_released("left"):
		left = false
	if event.is_action_pressed("right"):
		right = true
	elif event.is_action_released("right"):
		right = false
	if event.is_action_released("jump"):
		apply_impulse(Vector3.UP * speed)
	if event.is_action_released("stop_h_v"):
		apply_impulse(-transform.basis.z * 10 * speed)
