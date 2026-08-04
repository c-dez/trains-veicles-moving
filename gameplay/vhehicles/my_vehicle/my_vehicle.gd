extends VehicleBody3D

#wheels
@onready var fl:VehicleWheel3D = $FLWheel
@onready var fr:VehicleWheel3D = $FRWheel
@onready var rl:VehicleWheel3D = $RLWheel
@onready var rr:VehicleWheel3D = $RRWheel


@export var accel:float = 1.0
@export var traction = TRACTION.FRONT
enum TRACTION {
    FRONT,
    REAR
}