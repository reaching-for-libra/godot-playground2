extends KinematicBody2D
# onready var _animated_sprite = $AnimatedSprite

var _velocity = Vector2.ZERO

var _max_jump_height = 70
var _time_to_jump_apex = .25
var _max_jump_distance = 100
var _max_run = _max_jump_distance / (2 * _time_to_jump_apex)

#see suvat calculations; s = ut + 1/2at^2, v^2 = u^2 + 2at, where u=0, scalar looking at only y dir
var _gravity : float = (2 * _max_jump_height) / pow(_time_to_jump_apex, 2)
var _max_jump_velocity : float = -1 * abs(_gravity) * _time_to_jump_apex

var _max_jumps = 2
var _jump_count = 0


var _move_x_direction: int = 0

var _jump_initiated = false
var _jump_sustained = false
var _jump_inactive = true
var _is_jumping = false

        

func process_input():

    if Input.is_action_pressed("move_right", true) and not Input.is_action_pressed("move_left"):
        # print_debug("move_right")
        _move_x_direction = 1

    elif Input.is_action_pressed("move_left", true) and not Input.is_action_pressed("move_right"):
        # print_debug("move_left")
        _move_x_direction = -1

    else:
        _move_x_direction = 0

    if Input.is_action_pressed("jump", true):

        if _jump_inactive:
            _jump_initiated = true
            _jump_inactive = false
        else:
            _jump_sustained = true
    elif Input.is_action_just_released("jump"):
        _jump_inactive = true
        _jump_initiated = false
        _jump_sustained = false



func _physics_process(delta):
    process_input()

    var velocity = _velocity

    # #flip sprite based on direction. maintain direction if not moving laterally
    # if _input_directions.move_right:
    #     _animated_sprite.flip_h = false 
    # elif _input_directions.move_left:
    #     _animated_sprite.flip_h = true

    # if _input_directions.move_left or _input_directions.move_right:
    #     _animated_sprite.play("run")
    # else:
    #     _animated_sprite.play("idle")

    #save in local variable
    var is_on_ground = self.is_on_floor()

    #apply lateral movement
    velocity.x = int(_move_x_direction * _max_run )

    #apply vertical movement
    if is_on_ground:
        _is_jumping = false
        _jump_count = 0

    #jump button initiates a new jump
    if _jump_initiated and (is_on_ground or _jump_count < _max_jumps):
        _jump_initiated = false
        _is_jumping = true
        velocity.y = _max_jump_velocity
        _jump_count += 1

    #user cancels jump before reaching apex
    if _is_jumping and _jump_inactive and velocity.y < 0:
        velocity.y = 0
    
    #apply gravity
    velocity.y += _gravity * delta

    #set snap to force collision with ground
    var snap = Vector2.ZERO if is_on_ground else Vector2.DOWN

    #apply movement
    _velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)



