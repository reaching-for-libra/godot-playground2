extends Actor

onready var _animated_sprite = $AnimatedSprite
onready var _hitbox = $PolygonHitBox

class InputDirections:
    var move_left: bool = false
    var move_right: bool = false
    var jump_start: bool = false
    var jump_sustain: bool = false


var _velocity = Vector2.ZERO
var _run_acceleration = 800

var _max_jump_height = 1
var _min_jump_height = 1
var _time_to_jump_apex = .25
var _max_jump_distance = 50
var _max_run = _max_jump_distance / (2 * _time_to_jump_apex)

#see suvat calculations; s = ut + 1/2at^2, v^2 = u^2 + 2at, where u=0, scalar looking at only y dir
var _gravity : float = (2 * _max_jump_height) / pow(_time_to_jump_apex, 2)
var _max_jump_velocity : float = -1 * abs(_gravity) * _time_to_jump_apex
var _min_jump_velocity : float = -1 * sqrt(2 * abs(_gravity) * _min_jump_height)

var _max_fall = 200

# var _jump_force = -160
var _jump_hold_time = 0.2
var _local_hold_time = 0
var _max_jumps = 2
var _jump_count = 0

var _input_directions := InputDirections.new()


func _input(event):

    _input_directions = InputDirections.new()

    if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
        _input_directions.move_right = true

    elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
        _input_directions.move_left = true


    if Input.is_action_just_pressed("jump"):
        _input_directions.jump_start = true
    elif Input.is_action_pressed("jump"):
        _input_directions.jump_sustain = true
        



func _physics_process(delta):

    var velocity = _velocity

    #flip sprite based on direction. maintain direction if not moving laterally
    if _input_directions.move_right:
        _animated_sprite.flip_h = false 
    elif _input_directions.move_left:
        _animated_sprite.flip_h = true

    if _input_directions.move_left or _input_directions.move_right:
        _animated_sprite.play("run")
    else:
        _animated_sprite.play("idle")

    #get direction from input
    # var input_directions := get_input_directions()

    # #flip sprite based on direction. maintain direction if not moving laterally
    # if input_directions.move_right:
    #     _animated_sprite.flip_h = false 
    # elif input_directions.move_left:
    #     _animated_sprite.flip_h = true

    # if input_directions.move_left or input_directions.move_right:
    #     _animated_sprite.play("run")
    # else:
    #     _animated_sprite.play("idle")


    var on_ground := Game.check_collisions(self, Vector2.DOWN, "Walls").size() > 0

    if on_ground:
        _jump_count = 0

    #jump initiated
    if _input_directions.jump_start and (on_ground or _jump_count < _max_jumps):
        velocity.y = _max_jump_velocity
        _local_hold_time = _jump_hold_time
        _jump_count += 1
    
    #jump previously initiated
    elif _local_hold_time > 0:
        
        #sustaining jump
        if not _input_directions.jump_sustain:

            #if going less than the min jump velocity, bump up to min
            if velocity.y > _min_jump_velocity:
                velocity.y = _min_jump_velocity
        
        #no longer sustaining
        else:
            _local_hold_time = 0

    _local_hold_time -= delta



    # _velocity.y += _gravity * delta
    # _delta_velocity = (_old_velocity + _velocity) * 0.5 * delta
    velocity.y += _gravity * delta
    # _velocity.y = move_toward(0, INF if _velocity.y >= 0 else -INF, _velocity.y * delta)

    #lateral
    var x_direction = 1 if _input_directions.move_right else -1 if _input_directions.move_left else 0
    # _velocity.x = move_toward(0, x_direction, _run_acceleration * delta)
    velocity.x = x_direction * _max_run * delta
    # print_debug([_gravity,velocity])
# 

    # _velocity.x = move_toward(_old_velocity.x, _max_run * x_direction, _run_acceleration * delta)
    # _velocity.y = move_toward(_old_velocity.y, INF , _gravity * delta)


    # var x_displacement = move_x(_velocity.x * delta, funcref(self, "on_collision_x"))
    # print_debug(x_displacement.collisions)
    # var y_displacement = move_y(_velocity.y * delta, funcref(self, "on_collision_y"))
    # print_debug(_velocity)
    var displacement = move(velocity)

    _velocity = displacement
    # print_debug(["after",_velocity])

    # if on_ground and x_displacement.collisions.size() > 0:
    #     print_debug([x_displacement.get_min_collision_y(), _hitbox.get_max_y()])
    #     x_displacement.displacement = x_displacement.get_min_collision_x() - _hitbox.get_max_x() + 1
    #     # y_displacement.displacement = -1 * (x_displacement.get_min_collision_y() - _hitbox.get_max_y())
    #     y_displacement.displacement = x_displacement.get_min_collision_y() - _hitbox.get_max_y() + 1


    # move_x_displacement(x_displacement.displacement)
    # move_y_displacement(y_displacement.displacement)



func on_collision_x() -> void:
    _velocity.x = 0
    zero_remainder_x()

func on_collision_y() -> void:
    _velocity.y = 0
    zero_remainder_y()







