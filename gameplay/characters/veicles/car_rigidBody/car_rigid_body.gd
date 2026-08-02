extends RigidBody3D
class_name CarRigid

# @onready var body: RigidBody3D = $Body

# suspension
var rest_dist: float = 0.5
var spring_strenght: float = 160
var spring_damping: int = 2

@onready var rayFR: RayCast3D = $RayFR
@onready var rayFL: RayCast3D = $RayFL
@onready var rayBR: RayCast3D = $RayBR
@onready var rayBL: RayCast3D = $RayBL

@export var wheels:Array[RayCast3D] 

func _ready() -> void:
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM

	center_of_mass = Vector3(0, -0.5, 0)

func _physics_process(_delta: float) -> void:
	for wheel in wheels:
		do_single_suspension(wheel)
	pass

func get_point_velocity(point:Vector3)->Vector3:
	return linear_velocity + angular_velocity.cross(point - global_position)


func do_single_suspension(suspension_ray:RayCast3D)->void:
	if not suspension_ray.is_colliding():
		return

	if suspension_ray.is_colliding():
		var contact := suspension_ray.get_collision_point()
		var spring_up_direction:= suspension_ray.global_transform.basis.y
		var spring_len := suspension_ray.global_position.distance_squared_to(contact)
		var offset := rest_dist - spring_len

		var spring_force := spring_strenght * offset

		# damping_force = damping * relative_velocity
		var world_vel := get_point_velocity(contact)
		var relative_vel := spring_up_direction.dot(world_vel)
		var spring_damp_force := spring_damping * relative_vel
		# var force_vector := spring_force * spring_up_direction
		var force_vector := (spring_force - spring_damp_force) * spring_up_direction

		var force_pos_offset := contact - global_position

		apply_force(force_vector, force_pos_offset)
	pass
