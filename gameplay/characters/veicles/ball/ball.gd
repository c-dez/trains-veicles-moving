extends Node3D

@onready var body :RigidBody3D = $RigidBody3D
@onready var ray :RayCast3D = body.get_node('RayCast3D')

var altura = 2
var fuerza = 5000.0

var damping = 800.0

var motor_force = 1000.0

var steering := 0.0

func _physics_process(_delta: float) -> void:
	spring()
	acelerate(_delta)
	try_steering(_delta)

func try_steering(_delta:float)->void:
	var input := Input.get_axis("right", "left")
	steering = lerp(steering , input, 4.0 * _delta)
	

func acelerate(_delta) ->void:
	var forward := -body.global_transform.basis.z
	#forward = forward.rotated(Vector3.UP, steering* 10)
	body.rotate_y(steering * 2.5 * _delta)
	var aceleracion = Input.get_action_strength('up')
	#var aceleracion = forward.rotated(Vector3.UP, steering * 8.0)

	body.apply_central_force(forward * aceleracion * motor_force)
	
func spring() ->void:
	if not ray.is_colliding():
		return
	var suelo = ray.get_collision_point()	
	
	var altura_actual = body.global_position.y - suelo.y
	var error = altura - altura_actual
	
	var _fuerza = error * fuerza
	_fuerza -= body.linear_velocity.y * damping
	
	body.apply_central_force(Vector3.UP * _fuerza)
