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


    # if displacement.y == 0:
    var y_movement = move_y(amount.y + displacement.y)
    if y_movement.collisions.size() > 0:
        # displacement.y = 0
        zero_remainder_y()
    else:
        displacement.y = round(y_movement.displacement.y)
    
    # print_debug(["asdf",displacement])
    
    move_x_displacement(int(displacement.x))
    move_y_displacement(int(displacement.y))
    # print_debug(global_position)
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

    # move up to the collision point, then recheck for collision, instead of just moving up one pixel_size
    # will have to think about different collision shapes - only move up if the collision is 3 points and 
    # not to steep a slot_updated

    while amount != 0:

        var displacement: Vector2 = Vector2.ZERO
        # print_debug("ground_check")
        var on_ground: bool = Game.check_collisions(self, Vector2.DOWN, "Walls", true).size() > 0

        # print_debug("collision_check")
        var collisions: Array = Game.check_collisions(self, Vector2(response.displacement.x + step, 0), "Walls", true)

        if collisions.size() > 0:
            if on_ground:
                # print_debug("slope_check")

                for i in range(0, collisions.size()):
                    var collision_response_value: Game.CollisionResponseValue =  collisions[i]
                    if collision_response_value.collision_polygon.size() > 0:
                        var collision_min_y = Game.get_min_collision_y(collision_response_value.collision_polygon)
                        var collision_min_x = Game.get_min_collision_x(collision_response_value.collision_polygon)
                        var asdf = collision_min_y - self._hitbox.get_max_y() + displacement.y 
                        var asdf2 = collision_min_x - self._hitbox.get_max_x() + displacement.x 
                        displacement.x = asdf2
                        displacement.y = asdf
                        print_debug(["abbbccc", collision_response_value.collision_polygon, self._hitbox.get_max_y(), displacement.y, collision_min_y, asdf, displacement ])
                        break

                amount -= step
                        
                # if a.size() == 0:
                #     # print_debug("HIiii")
                #     displacement.y -= 1
                #     displacement.x += step
                #     amount -= step
                # else:
                #     zero_remainder_x()
                #     amount = 0
            else:
                zero_remainder_x()
                amount = 0
        else:
            #check collision, one step over. 
            if on_ground:
                collisions = Game.check_collisions(self, Vector2(response.displacement.x + step, 1), "Walls")
                if collisions.size() == 0:
                    collisions = Game.check_collisions(self, Vector2(response.displacement.x + step, 2), "Walls")
                    if collisions.size() > 0:
                        displacement.y += 1

            zero_remainder_x()
            displacement.x += step
            amount -= step

        response.displacement.x += displacement.x
        response.displacement.y += displacement.y

    
    # print_debug(["a",response.displacement])
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

        # print_debug(response.displacement.y + step);
        var collisions : Array = Game.check_collisions(self, Vector2(0, response.displacement.y + step), "Walls")

        if collisions.size() > 0:
            # print_debug(response.displacement.y + step);
            # response.collisions.append_array(collisions)

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
    print_debug(["hmm", self.global_position.x, self._hitbox.global_position.x])

func move_y_displacement(displacement: int) -> void:
    global_position.y += displacement
