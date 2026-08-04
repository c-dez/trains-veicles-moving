extends RigidBody3D
# no he encontrado soluciones satisfactorias a los compromisos usando RigidBody para un carro, pero fue una buena base para drifting

@export var accel_curve: Curve
@export var brake_curve: Curve

var velocimetro_time = 0.2
var _velocimetro_time = velocimetro_time

var speed_input := 0.0
var turn_input := 0.0
var acceleration := 500.0
var brake_force := 2.5
var steering_angle := 20.0
var steering_mult := 1.0
var turn_speed := 2.0

@onready var velocimetro_label: Label = $Label
@onready var mesh: MeshInstance3D = $Mesh
@onready var ray: RayCast3D = $Ray
# @onready var spring: SpringArm3D = $SpringArm3D


## IDEAS para mejorar el feeling:
## Podria al frenar incrementar lateral_speed, steering
# inclinar camara al drifting
# problema: el mejor feling lo tengo cuando no suelto el acelerador y freno para controlar steering, el problema es que nop tiene caso que el jugador interactue con acelerador y quiero que sea una mezvla entre acelerador y freno para drift


func _ready() -> void:
    # spring.top_level = true
    ray.top_level = true
    mesh.top_level = true
    pass


func _process(_delta: float) -> void:
    set_acceleration(_delta)
    set_turn_input()


func _physics_process(delta: float) -> void:
    set_object_global_position(mesh)
    set_object_global_position(ray, Vector3(0, -0.9, 0))
   
    if not ray.is_colliding():
        return

    girar(delta)
    apply_acceleration(delta)
    pass


func set_acceleration(_delta: float) -> void:
    var r2_trigger = Input.get_action_strength('R2_button')
    var accel_mult = accel_curve.sample(r2_trigger)
    var l2_trigger = Input.get_action_strength('L2_button')
    var brake_mult = brake_curve.sample(l2_trigger)

    # Suma a steering_angle al frenar
    steering_angle = 20 + (brake_mult * 10)
    ##SEPARAR BREAK Y ACCEL
    var target_speed_input = (acceleration * accel_mult) - Input.get_action_strength('L2_button') * acceleration * brake_force

    #hace que la aplicacion de speed sea interpolado
    speed_input = move_toward(
        speed_input,
        target_speed_input,
        70 * _delta
    )
    pass


func velocimetro(delta: float, forward_speed: float) -> void:
    _velocimetro_time -= delta
    if _velocimetro_time < 0:
        velocimetro_label.text = str(forward_speed * 3.6)
        _velocimetro_time = velocimetro_time
    pass


## toma los inputs de jugador y los convierte a radians para girar direccion de movimiento y los asigna a turn_input
func set_turn_input() -> void:
    turn_input = (Input.get_action_strength('left') - Input.get_action_strength('right')) * deg_to_rad(steering_angle)
    pass


## object.global_position = global_position
func set_object_global_position(object: Node3D, _offset: Vector3 = Vector3.ZERO) -> void:
    object.global_position = global_position + _offset
    pass


func girar(delta: float) -> void:
    if speed_input > 1.0 or speed_input < 1.0:
        var current_basis := mesh.global_transform.basis
        var rotated_basis := current_basis.rotated(current_basis.y, turn_input)
        var smoothed_basis := current_basis.orthonormalized().slerp(
            rotated_basis.orthonormalized(), delta * turn_speed
        )
        mesh.global_basis = smoothed_basis.orthonormalized()
    pass


func apply_acceleration(delta: float) -> void:
    ## forward direction
    var forward := -mesh.global_transform.basis.z
    ## right direction
    # var right := mesh.global_transform.basis.x

    apply_central_force(forward * speed_input)
    velocimetro(delta, get_moving_speed(forward))
    pass


## Calcula velocidad en m/s de movimiento hacia adelante, tambien puede calcul;ar la velocidad lateral dandole right_basis
func get_moving_speed(forward_basis: Vector3) -> float:
    var forward_speed := linear_velocity.dot(forward_basis)
    return forward_speed