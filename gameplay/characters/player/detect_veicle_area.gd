extends Area3D
# enter car

const VEICLE_ENTER_NAME := "EnterArea"
func _ready() -> void:
	connect('area_entered', on_veicle_area_entered)
	connect('area_exited', on_veicle_area_exited)


func on_veicle_area_entered(area: Area3D) -> void:
	if not area.name == VEICLE_ENTER_NAME:
		return
	if owner.on_veicle == true:
		return
	owner.veicle_node = area.owner
	# owner.on_veicle = true
	owner.can_enter_car = true

	pass


func on_veicle_area_exited(area: Area3D) -> void:
	if not area.name == VEICLE_ENTER_NAME:
		return
	owner.can_enter_car = false
	owner.veicle_node = null

	
	pass
