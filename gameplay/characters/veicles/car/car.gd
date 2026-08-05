extends VehicleBody3D

@export var force = 5000.0
@export var brake_force: float = 5.0
@export var max_steer = deg_to_rad(10)


# wheels
@onready var fr_Wheel: VehicleWheel3D = $FR_Wheel
@onready var fl_Wheel: VehicleWheel3D = $FL_Wheel
@onready var br_Wheel: VehicleWheel3D = $BR_Wheel
@onready var bl_Wheel: VehicleWheel3D = $BL_Wheel

# traction
## FWD front wheel drive RWD read wheel drive
@export var traction = TRACTION.fwd
enum TRACTION {
    fwd,
    rwd
}

#Velocimetro
@onready var velocimetro: Label = $Label
var is_player_in: bool = false

# var speed = linear_velocity.length()
# var ratio = clamp(speed / MAX_SPEED_MS, 0.0, 1.0)

# engine_force = lerp(3000.0, 0.0, ratio)
var max_speed_km: float = 100.0
var max_speed_m: float = max_speed_km / 3.6
var max_reverse_speed_km: float = -20.0
var max_reverse_speed_m: float = max_reverse_speed_km / 3.6


func _ready() -> void:
    _set_traction()

var time := 0.5
var _time := time
func _physics_process(delta: float) -> void:
    var forward = - global_transform.basis.z

    var current_speed_ms = linear_velocity.dot(forward)

    _time -= delta
    if _time < 0:
    # velocimetro.text = str(linear_velocity.length())
        velocimetro.text = "%.1f KM/H" % (current_speed_ms * 3.6)
        _time = time


    if not is_player_in:
        engine_force = 0
        brake = 10
        steering = 0
        return

    else:
        steering = move_toward(steering, Input.get_axis('right', 'left') * max_steer, delta * 1.5)

        
        var ratio = clamp(current_speed_ms / max_speed_m, 0.0, 1.0)
        engine_force = lerp(Input.get_action_strength('R2_button') * force, 0.0, ratio)
        print(engine_force)
       
        
        #brake
        # reverse(current_speed_ms)

func reverse(speed: float) -> void:
   
       

    pass

func _set_traction() -> void:
    fr_Wheel.use_as_steering = true
    fl_Wheel.use_as_steering = true
    br_Wheel.use_as_steering = false
    bl_Wheel.use_as_steering = false
    match traction:
        TRACTION.fwd:
            fr_Wheel.use_as_traction = true
            fl_Wheel.use_as_traction = true
            br_Wheel.use_as_traction = false
            bl_Wheel.use_as_traction = false
      
            pass

        TRACTION.rwd:
            fr_Wheel.use_as_traction = false
            fl_Wheel.use_as_traction = false
            br_Wheel.use_as_traction = true
            bl_Wheel.use_as_traction = true
            pass

func _set_steering() -> void:
    pass
