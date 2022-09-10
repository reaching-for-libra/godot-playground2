extends Polygon2D
class_name PolygonHitBox



func get_min_x():
    var min_x = null

    for i in range(0,polygon.size()):
        if min_x == null or polygon[i].x + global_position.x < min_x:
            min_x = polygon[i].x + global_position.x
    
    return min_x

func get_max_x():
    var max_x = null

    for i in range(0,polygon.size()):
        if max_x == null or polygon[i].x + global_position.x > max_x:
            max_x = polygon[i].x + global_position.x
    
    return max_x

func get_min_y():
    var min_y = null

    for i in range(0,polygon.size()):
        if min_y == null or polygon[i].y + global_position.y < min_y:
            min_y = polygon[i].y + global_position.y
    
    return min_y

func get_max_y():
    var max_y = null

    for i in range(0,polygon.size()):
        if max_y == null or polygon[i].y + global_position.y > max_y:
            max_y = polygon[i].y + global_position.y
    
    return max_y





func _physics_process(_delta):
    update()



func intersects(other: PolygonHitBox, offset: Vector2) -> PoolVector2Array:

    
    #rotate the source
    var source_vector_array: PoolVector2Array = PoolVector2Array([])

    source_vector_array.append(
        Vector2(
            self.global_position.x + self.polygon[0].x + offset.x, self.global_position.y + self.polygon[0].y + offset.y
        )
    )
    for i in range(1, self.polygon.size()):
        var rotated_point = self.polygon[i].rotated(self.get_parent().rotation)
        var point = Vector2(
            self.global_position.x + rotated_point.x + offset.x,
            self.global_position.y + rotated_point.y + offset.y
        )

        source_vector_array.append(Vector2(round(point.x), round(point.y)))
        # source_vector_array.append(point)
    

    #rotate the target
    var target_vector_array: PoolVector2Array = PoolVector2Array([])

    target_vector_array.append(
        Vector2(
            other.global_position.x + other.polygon[0].x, other.global_position.y + other.polygon[0].y
        )
    )

    for i in range(1, other.polygon.size()):
        var rotated_point = other.polygon[i].rotated(other.get_parent().rotation)
        var point = Vector2(
            other.global_position.x + rotated_point.x,
            other.global_position.y + rotated_point.y
        )

        target_vector_array.append(Vector2(round(point.x), round(point.y)))
        # target_vector_array.append(point)


    #get intersections
    var g = Geometry
    var intersections = g.intersect_polygons_2d(source_vector_array, target_vector_array)

    var result: PoolVector2Array = []

    for i in range(0, intersections.size()):
        result += intersections[i]

    # if result.size() > 0 and other.get_parent().name == "Wall2":
    #     print_debug([self.get_parent().name, other.get_parent().name])
    #     print_debug([source_vector_array])
    #     print_debug([target_vector_array])
    #     print_debug(["result",result])
    return result




