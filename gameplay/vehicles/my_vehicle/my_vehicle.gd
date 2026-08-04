extends VehicleBody3D

#wheels
@onready var fl: VehicleWheel3D = $FLWheel
@onready var fr: VehicleWheel3D = $FRWheel
@onready var rl: VehicleWheel3D = $RLWheel
@onready var rr: VehicleWheel3D = $RRWheel

@onready var wheels_array: Array[VehicleWheel3D] = [
    fl, fr, rl, rr
]

@export var traction := TRACTION.FRONT
enum TRACTION {
    FRONT,
    REAR
}
@export var rest_lenght: float = 0.3
@export var stiffness: float = 50

# steering
@export var max_steering :float = 20
@export var engine_speed = 100


func _ready() -> void:
    _set_wheels_rest_lenght()
    _set_traction()
    _set_stiffness()



func _physics_process(_delta: float) -> void:
    steer_car()
    if Input.is_action_pressed('up'):
        engine_force = engine_speed
    else:
        engine_force = 0

    if Input.is_action_pressed('down'):
        brake = 10
    else:
        brake = 0




    print(linear_velocity.dot(Vector3.MODEL_REAR) * 3.6)

func steer_car()->void:
    var steering_input = Input.get_axis('right','left')
    steering = steering_input * deg_to_rad(max_steering)
    pass
## largo total de resorte suspension
func _set_wheels_rest_lenght() -> void:
    for wheel in wheels_array:
        wheel.wheel_rest_length = rest_lenght

func _set_stiffness() -> void:
    for wheel in wheels_array:
        wheel.suspension_stiffness = stiffness
    pass

func _set_traction() -> void:
    fl.use_as_steering = true
    fr.use_as_steering = true

    rl.use_as_traction = false
    rr.use_as_traction = false

    match traction:
        TRACTION.FRONT:
            fl.use_as_traction = true
            fr.use_as_traction = true
            rl.use_as_traction = false
            rr.use_as_traction = false
            
            pass
        TRACTION.REAR:
            fl.use_as_traction = false
            fr.use_as_traction = false
            rl.use_as_traction = true
            rr.use_as_traction = true
            pass
