tool
extends Node2D
class_name HitBox

export var _top_left: Vector2 = Vector2(0,0)
export var _width = 16
export var _height = 16
export var _angle = 0
export var _color = Color(0,0,1,.5)


var _local_center : Vector2 setget ,get_local_center
var _global_center : Vector2 setget ,get_global_center

# var _local_polygon : Vector2 setget ,get_local_polygon
# var _global_polygon : Vector2 setget ,get_global_polygon

func get_local_center() -> Vector2:
    return Vector2(_top_left.x + round(_width / 2), _top_left.y + round(_height / 2))

func get_global_center() -> Vector2:
    # return global_position + _local_center
    var top_left : Vector2 = (global_position + _top_left)
    return Vector2(top_left.x + round(_width / 2), top_left.y + round(_height / 2))

# func get_local_polygon() -> Polygon2D:
#     var vectors = PoolVector2Array([
#         self._top_left,
#         Vector2(self._top_left.x + self._width, self._top_left.y),
#         Vector2(self._top_left.x + self._width, self._top_left.y + self._height),
#         Vector2(self._top_left.x, self._top_left.y + self._height),
#     ])
#     return Polygon2D


# func get_global_center() -> Vector2:
#     # return global_position + _local_center
#     var top_left : Vector2 = (global_position + _top_left)
#     return Vector2(top_left.x + round(_width / 2), top_left.y + round(_height / 2))

# func get_rotated_points(top_left: Vector2, width, height, angle) -> PoolVector2Array:
func get_rotated_points(center: Vector2, width, height, angle) -> PoolVector2Array:

    # var center : Vector2 = Vector2(top_left.x + (width / 2), top_left.y + (height / 2))
    # var center : Vector2 = Vector2(center_coordinates.x, center_coordinates.y)

    # create the (normalized) perpendicular vectors
    var radians = deg2rad(angle)

    var v1 : Vector2 = Vector2(cos(radians), sin(radians))
    var v2 : Vector2 = Vector2(-v1.y, v1.x)  # rotate by 90

    # scale them appropriately by the dimensions
    v1 *= width / 2
    v2 *= height / 2

    # return the corners by moving the center of the rectangle by the vectors
    var vectors = PoolVector2Array([
        (center + v1 + v2),
        (center - v1 + v2),
        (center - v1 - v2),
        (center + v1 - v2),
    ])

    #snap to pixel size
    for i in range(0, vectors.size()):
        vectors[i].x = round(vectors[i].x)
        vectors[i].y = round(vectors[i].y)

    return vectors


# func get_rotated_points() -> PoolVector2Array:

#     var radians = deg2radians(self._angle)
#     var g = Geometry
#     var a = polygon.new()
#     a.rotate()




func _draw():

    # var self_top_left = Vector2(self._x, self._y)
    var rotated = get_rotated_points(self._local_center, self._width, self._height, self._angle)
    var colors = PoolColorArray([
        self._color,
    ])

    draw_polygon(rotated, colors)


func _physics_process(_delta):
    update()


func intersects(other: HitBox, offset: Vector2) -> PoolVector2Array:

    var g = Geometry

    # var self_top_left : Vector2 = Vector2(self._left + offset.x, self._top + offset.y)
    var polygon_1 = self.get_rotated_points(self._global_center + offset, self._width, self._height, self._angle)

    # var other_top_left : Vector2 = Vector2(other._left, other._top)
    var polygon_2 = other.get_rotated_points(other._global_center, other._width, other._height, other._angle)


    var polygon_intersection = g.intersect_polygons_2d(polygon_1, polygon_2)
    # print_debug(polygon_intersection)
    return polygon_intersection

