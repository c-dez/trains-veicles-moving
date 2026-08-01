extends Node3D


@onready var path : PathFollow3D = $Path3D/PathFollow3D

var move_speed = 20.0


func _ready() -> void:
    print(path)
func _physics_process(delta: float) -> void:
    path.progress += move_speed * delta
