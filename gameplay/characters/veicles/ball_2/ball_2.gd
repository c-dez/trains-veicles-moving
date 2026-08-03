extends RigidBody3D
@onready var velocimetro_label: Label = $Label
var time = 0.2
var _time = time
@onready var mesh: MeshInstance3D = $Mesh
@onready var ray: RayCast3D = $Ray
# @onready var spring: SpringArm3D = $SpringArm3D

var speed_input := 0.0
var turn_input := 0.0
var acceleration := 500.0
var brake_force: float = 2.5
var steering_angle: float = 20
var steering_mult = 1.0
var turn_speed := 2.0
var offset := Vector3(0.0, -1.0, 0.0)
@export var accel_curve: Curve
@export var brake_curve: Curve


# var direction = linear_velocity.normalized()

# var forward_speed = forward.dot(direction)


func _ready() -> void:
    # spring.top_level = true
    ray.top_level = true
    mesh.top_level = true
    pass


func _process(_delta: float) -> void:
    var r2_trigger = Input.get_action_strength('R2_button')
    var accel_mult = accel_curve.sample(r2_trigger)
    var l2_trigger = Input.get_action_strength('L2_button')
    var brake_mult = brake_curve.sample(l2_trigger)

    # print(accel_mult)

    # var steering_multiplied = 40 * Input.get_action_strength('L2_button')

    # steering_angle= 40 if Input.is_action_pressed('L2_button') else 20
    steering_angle = 20.0 + (brake_mult * 10)
    # print(steering_angle)

    var target_speed_input = (acceleration * accel_mult) - Input.get_action_strength('L2_button') * acceleration * brake_force

   
    # var target_speed_input = (acceleration * accel_mult) - (acceleration*brake_mult)

    speed_input = move_toward(
        speed_input,
        target_speed_input,
        70 * _delta

    )

    turn_input = (Input.get_action_strength('left') - Input.get_action_strength('right')) * deg_to_rad(steering_angle)
    

func _physics_process(delta: float) -> void:
    mesh.global_position = global_position
    ray.global_position = global_position + Vector3(0.0, -0.9, 0.0)
    # spring.global_position = global_position

    # spring.rotation.y = mesh.rotation.y
    if not ray.is_colliding():
        return

    if speed_input > 1.0 or speed_input < 1.0:
        var current_basis := mesh.global_transform.basis
        var rotated_basis := current_basis.rotated(current_basis.y, turn_input)
        # var smoothed_basis := current_basis.slerp(rotated_basis, delta * turn_speed)
        var smoothed_basis := current_basis.orthonormalized().slerp(
            rotated_basis.orthonormalized(), delta * turn_speed
        )

        mesh.global_basis = smoothed_basis.orthonormalized()
        pass
    ## forward direction
    var forward = - mesh.global_transform.basis.z
    ## right direction
    var right := mesh.global_transform.basis.x

    apply_central_force(forward * speed_input)

    # var dir = linear_velocity.normalized()

    # var forward_speed = forward.dot(dir)
    # print(forward_speed)

    var forward_speed = linear_velocity.dot(forward)
    var lateral_speed := linear_velocity.dot(right)

    #Velocimetro
    velocimetro(delta, forward_speed)




func velocimetro(delta: float, forward_speed: Vector3) -> void:
    _time -= delta
    if _time < 0:
        velocimetro_label.text = str(forward_speed * 3.6)
        _time = time


## IDEAS para mejorar el feeling:
## Podria al frenar incrementar lateral_speed, steering
# inclinar camara al drifting
# problema: el mejor feling lo tengo cuando no suelto el acelerador y freno para controlar steering, el problema es que nop tiene caso que el jugador interactue con acelerador y quiero que sea una mezvla entre acelerador y freno para drift
