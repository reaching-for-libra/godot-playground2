extends Node2D
class_name Actor

var _remainder = Vector2.ZERO

func move_x(amount, callback) -> void:
    _remainder.x += amount
    var move = round(_remainder.x)
    if move != 0:
        _remainder.x -= move
        move_x_exact(move, callback)


func move_x_exact(amount, callback) -> void:

    var step = sign(amount)

    while amount != 0:
        if Game.check_walls_collision(self, Vector2(step, 0)):
            callback.call_func()
            return

        global_position.x += step
        amount -= step


func move_y(amount, callback) -> void:
    _remainder.y += amount
    var move = round(_remainder.y)
    if move != 0:
        _remainder.y -= move
        move_y_exact(move, callback)


func move_y_exact(amount, callback) -> void:

    var step = sign(amount)

    while amount != 0:
        if Game.check_walls_collision(self, Vector2(0, step)):
            callback.call_func()
            return
        global_position.y += step
        amount -= step



func zero_remainder_x() -> void:
    _remainder.x = 0

func zero_remainder_y() -> void:
    _remainder.y = 0
