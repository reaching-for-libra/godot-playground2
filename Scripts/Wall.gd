extends Node2D

onready var _hitbox = $HitBox

export var _x = 0
export var _y = 0
export var _width = 16
export var _height = 16
export var _angle = 0
export var _color = Color(0,0,1,.5)



func _ready():
    _hitbox._x = _x
    _hitbox._y = _y
    _hitbox._width = _width
    _hitbox._height = _height
    _hitbox._angle = _angle
    _hitbox._color = _color

    add_to_group("Walls")


