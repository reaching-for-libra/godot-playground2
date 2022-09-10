extends Node2D
class_name Actor

var _remainder = Vector2.ZERO

func move(amount: Vector2) -> Vector2:
    var displacement: Vector2 = Vector2.ZERO

    var x_movement = move_x(amount.x)
    displacement.x = x_movement.displacement.x
    displacement.y = x_movement.displacement.y
    # print_debug(displacement)

    # if x_movement.collisions.size() > 0:
    #     var on_ground := Game.check_walls_collision(self, Vector2.DOWN).size() > 0
    #     if true:
    #         var slope_angle = Vector2(x_movement.get_min_collision_x(), x_movement.get_max_collision_y()).angle()
    #         # var slope_angle = Vector2(x_movement.get_min_collision_x(), x_movement.get_max_collision_y()).angle_to(Vector2.UP)
    #         print_debug(Vector2(x_movement.get_min_collision_x(), x_movement.get_max_collision_y()))
    #         var move_distance = abs(amount.x)
    #         var ascend_displacement_y = sin(slope_angle) * move_distance 
    #         var ascend_displacement_x = cos(slope_angle) * move_distance * sign(amount.x)
    #         displacement.x = floor(ascend_displacement_x)
    #         displacement.y = floor(ascend_displacement_y * -1)
    #         # print_debug(displacement)
    #     else:
    #         zero_remainder_x()
    # else:
    #     displacement.x = round(x_movement.displacement.x)


    if displacement.y == 0:
        var y_movement = move_y(amount.y)
        if y_movement.collisions.size() > 0:
            # displacement.y = 0
            zero_remainder_y()
        else:
            displacement.y += round(y_movement.displacement.y)
    
    
    move_x_displacement(displacement.x)
    move_y_displacement(displacement.y)
    return displacement



func move_x(amount) -> Game.MovementResponse:

    var response = Game.MovementResponse.new()

    _remainder.x += amount
    var move = round(_remainder.x)
    if move != 0:
        _remainder.x -= move
        response = move_x_exact(move)
    
    return response


func move_x_exact(amount) -> Game.MovementResponse:

    var response = Game.MovementResponse.new()

    var step = sign(amount)

    while amount != 0:
        var displacement: Vector2 = Vector2.ZERO
        var collisions: PoolVector2Array = Game.check_walls_collision(self, Vector2(amount, 0))
        if collisions.size() > 0:
            var on_ground := Game.check_walls_collision(self, Vector2.DOWN).size() > 0
            if true:
                # var slope_angle = Vector2(floor(Game.get_min_collision_x(collisions)), floor(Game.get_max_collision_y(collisions))).angle()
                var slope_angle = Vector2(floor(Game.get_min_collision_x(collisions)), floor(Game.get_max_collision_y(collisions))).angle_to(Vector2.UP)
                # print_debug(rad2deg(slope_angle))
                var move_distance = abs(amount)
                var ascend_displacement_y = sin(slope_angle) * move_distance 
                var ascend_displacement_x = cos(slope_angle) * move_distance * sign(amount)
                displacement.x = floor(ascend_displacement_x)
                displacement.y = floor(ascend_displacement_y)
                print_debug(displacement)
            else:
                response.displacement = Vector2.ZERO
                zero_remainder_x()
        else:
            displacement.x = round(amount)
            # if collisions.size() > 0:
        #     response.collisions += collisions
        #     break

        response.displacement.x += displacement.x
        response.displacement.y += displacement.y
        amount -= step
    
    return response


func move_y(amount) -> Game.MovementResponse:

    var response = Game.MovementResponse.new()

    _remainder.y += amount
    var move = round(_remainder.y)
    if move != 0:
        _remainder.y -= move
        response = move_y_exact(move)
    
    return response


func move_y_exact(amount) -> Game.MovementResponse:

    var response = Game.MovementResponse.new()

    var step = sign(amount)

    while amount != 0:

        var collisions : PoolVector2Array = Game.check_walls_collision(self, Vector2(0, amount))

        if collisions.size() > 0:
            response.collisions += collisions

            # var y_array = []

            # for i in range(0, collisions.size()):
            #     y_array.append(collisions[i].y)

            # if global_position.y + step + response.displacement.y < Game.get_min_collision_y(collisions):
            #     response.displacement.y -= Game.get_min_collision_y(collisions) - (global_position.y + step + response.displacement.y)

            break

        response.displacement.y += int(step)
        amount -= step

    return response



func zero_remainder_x() -> void:
    _remainder.x = 0

func zero_remainder_y() -> void:
    _remainder.y = 0


func move_x_displacement(displacement: int) -> void:
    global_position.x += displacement

func move_y_displacement(displacement: int) -> void:
    global_position.y += displacement
