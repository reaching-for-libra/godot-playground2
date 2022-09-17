extends Node2D

onready var _hitbox = $PolygonHitBox

# export var _top_left : Vector2 = Vector2(0,0)
# export var _width = 16
# export var _height = 16
# export var _angle = 0
# export var _color = Color(0,0,1,.5)



func _ready():
    self.rotation_degrees = round(self.rotation_degrees)
    # _hitbox._top_left = _top_left
    # _hitbox._width = _width
    # _hitbox._height = _height
    # _hitbox._angle = _angle
    # _hitbox._color = _color

    # _hitbox.rotate(self.rotation)

    add_to_group("Floors")


