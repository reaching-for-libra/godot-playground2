tool
extends Node2D
class_name HitBox

export var _x = 0
export var _y = 0
export var _width = 16
export var _height = 16
export var _angle = 0
export var _color = Color(0,0,1,.5)


var _left setget ,get_left
var _right setget ,get_right
var _top setget ,get_top
var _bottom setget ,get_bottom

func get_left() -> int:
    return global_position.x + _x

func get_right() -> int:
    return global_position.x + _x + _width

func get_top() -> int:
    return global_position.y + _y

func get_bottom() -> int:
    return global_position.y + _y + _height

func _draw():

    # draw_rect(Rect2(_x, _y, _width, _height), _color)


    var radians = deg2rad(_angle)

    # var source = Vector2(_x, _y)
    # var target = Vector2(_x + _width, _y + _height)
    # var from_around = source - target

    # var post_rotation_x = (from_around.x * cos(radians)) - (from_around.y * sin(radians))
    # var post_rotation_y = (from_around.x * sin(radians)) + (from_around.y * cos(radians))

    # var new_rect_vector = target + Vector2(post_rotation_x, post_rotation_y)

    # var rect = Rect2(new_rect_vector, Vector2(_width, _height))

    var source = Vector2(_x, _y)
    var center = Vector2(_x + (_width / 2), _y + (_height / 2))

    var post_rotation_x = center.x + ((source.x - center.x) * cos(radians)) - ((source.y - center.y) * sin(radians))
    var post_rotation_y = center.y + ((source.x - center.x) * sin(radians)) + ((source.y - center.y) * cos(radians))

    var new_source = Vector2(post_rotation_x, post_rotation_y)
    var rect = Rect2(Vector2.ZERO, Vector2(_width, _height))

    draw_set_transform(new_source, radians, Vector2.ONE)
    draw_rect(rect, _color)

    # draw_set_transform(Vector2.ZERO, deg2rad(_angle), Vector2(_width, _height))
    # var rect = Rect2(_x, _y, 1, 1)
    # draw_rect(rect, _color)


    # draw_set_transform(Vector2.ZERO, deg2rad(_angle), Vector2.ONE)

    # var centered_vector = Vector2(Vector2(self._x + (self._width / 2), self._y + (self._height / 2))
    # x = cos(angle)*x - sin(angle)*y y = cos(angle)*x + sin(angle)*y

    # var array = [PoolVector2Array()]
    # array[0].push_back(Vector2(12, 34))
    # draw_colored_polygon

    # # draw_set_transform(Vector2(self._x + (self._width / 2), self._y + (self._height / 2)), deg2rad(_angle), Vector2.ONE)
    # # draw_set_transform(Vector2(self._x + (self._width / 2), self._y + (self._height / 2)), deg2rad(_angle), Vector2.ONE)

    # draw_rect(Rect2(Vector2.ZERO, Vector2(_width, _height)), _color)

func _physics_process(delta):
    update()


func intersects(other: HitBox, offset: Vector2) -> bool:
    var result = ( 
        (self._right + offset.x) > other._left && 
        (self._left + offset.x) < other._right &&
        (self._bottom + offset.y) > other._top && 
        (self._top + offset.y) < other._bottom
    )
    
    return result

func intersects2(other: HitBox, offset: Vector2) -> bool:

    #https://phretaddin.github.io/post/rotated-rectangle-collisions/

    var self_half_width = self._width / 2;
    var self_half_height = self._height / 2;
    var other_half_width = other._width / 2;
    var other_half_height = other._height / 2;

    var self_x_plus_half_width = self._left + offset.x + self_half_width
    var self_y_plus_half_height = self._top + offset.y + self_half_height
    var other_x_plus_half_width = other._left + other_half_width
    var other_y_plus_half_height = other._top + other_half_height

    var self_cos_angle = cos(deg2rad(self._angle))
    var self_sin_angle = sin(deg2rad(self._angle))
    var other_cos_angle = cos(deg2rad(other._angle))
    var other_sin_angle = sin(deg2rad(other._angle))

    var r1RX = (
        other_cos_angle *
        (self_x_plus_half_width - other_x_plus_half_width) +
        other_sin_angle *
        (self_y_plus_half_height - other_y_plus_half_height) +
        other_x_plus_half_width -
        self_half_width
    )
    var r1RY = (
        -other_sin_angle *
        (self_x_plus_half_width - other_x_plus_half_width) +
        other_cos_angle *
        (self_y_plus_half_height - other_y_plus_half_height) +
        other_y_plus_half_height -
        self_half_height
    )

    var r2RX = (
        self_cos_angle *
        (other_x_plus_half_width - self_x_plus_half_width) +
        self_sin_angle *
        (other_y_plus_half_height - self_y_plus_half_height) +
        self_x_plus_half_width -
        other_half_width
    )

    var r2RY = (
        -self_sin_angle *
        (other_x_plus_half_width - self_x_plus_half_width) +
        self_cos_angle *
        (other_y_plus_half_height - self_y_plus_half_height) +
        self_y_plus_half_height -
        other_half_height
    )

    var cosR1AR2A = abs(self_cos_angle * other_cos_angle + self_sin_angle * other_sin_angle)
    var sinR1AR2A = abs(self_sin_angle * other_cos_angle - self_cos_angle * other_sin_angle)
    var cosR2AR1A = abs(other_cos_angle * self_cos_angle + other_sin_angle * self_sin_angle)
    var sinR2AR1A = abs(other_sin_angle * self_cos_angle - other_cos_angle * self_sin_angle)

    var r1BBH = self._width * sinR1AR2A + self._height * cosR1AR2A
    var r1BBW = self._width * cosR1AR2A + self._height * sinR1AR2A
    var r1BBX = r1RX + self_half_width - r1BBW / 2
    var r1BBY = r1RY + self_half_height - r1BBH / 2

    draw_rect(Rect2(r1BBX, r1BBY, r1BBW, r1BBH), Color(1,1,1,-1))

    var r2BBH = other._width * sinR2AR1A + other._height * cosR2AR1A
    var r2BBW = other._width * cosR2AR1A + other._height * sinR2AR1A
    var r2BBX = r2RX + other_half_width - r2BBW / 2
    var r2BBY = r2RY + other_half_height - r2BBH / 2

    draw_rect(Rect2(r2BBX, r2BBY, r2BBW, r2BBH), Color(1,1,1,-1))

    return (
        self._left + offset.x < r2BBX + r2BBW and 
        self._left + offset.x + self._width > r2BBX and 
        self._top + offset.y < r2BBY + r2BBH and 
        self._top + offset.y + self._height > r2BBY and
        other._left < r1BBX + r1BBW and
        other._left + other._width > r1BBX and
        other._top < r1BBY + r1BBH and
        other._top + other._height > r1BBY
    )
