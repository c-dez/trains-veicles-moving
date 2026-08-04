extends VehicleBody3D

#wheels
@onready var fl:VehicleWheel3D = $FLWheel
@onready var fr:VehicleWheel3D = $FRWheel
@onready var rl:VehicleWheel3D = $RLWheel
@onready var rr:VehicleWheel3D = $RRWheel


@export var traction :=TRACTION.FRONT
enum TRACTION {
    FRONT,
    REAR
}


func _ready() -> void:
    _set_traction()



func _set_traction()->void:
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