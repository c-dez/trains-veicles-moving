extends Area3D
@onready var timer: = Timer.new()
var time:float = 0
var time_dic:Dictionary
var is_time_runing:bool = false

func _ready() -> void:
    connect('body_entered', on_body_entered)
    timer.autostart =false
    timer.one_shot = true

func _physics_process(delta: float) -> void:
    time_runing(delta)
    pass
var index = 0
func on_body_entered(body:Node3D)->void:
    if not body.name == 'Ball_2':
        return
    start_timer()
    index +=1
    var lap = 'Lap %d'%(index - 1)
   
    time_dic[lap] = time
    print(time)
    time = 0.0

    pass

func time_runing(delta:float) ->void:
    if is_time_runing:
        time += delta

func start_timer()->void:
    is_time_runing = true