extends Node3D

@onready var rear_camera:Camera3D = $SubViewport/RearCamera

@onready var mirror:MeshInstance3D = $mirror

func _process(delta: float) -> void:
    rear_camera.global_basis = mirror.global_basis
    rear_camera.global_position = mirror.global_position
    # rear_camera.rotation.x = 0
    rear_camera.global_basis.z *= -1

    pass