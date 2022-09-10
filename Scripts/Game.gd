extends Node

class MovementResponse:
    var displacement: Vector2 = Vector2.ZERO
    var collisions: PoolVector2Array = []



func get_min_collision_x(collisions: PoolVector2Array):
    var min_x = null

    for i in range(0,collisions.size()):
        if min_x == null or collisions[i].x < min_x:
            min_x = collisions[i].x
    
    return min_x

func get_max_collision_x(collisions: PoolVector2Array):
    var max_x = null

    for i in range(0,collisions.size()):
        if max_x == null or collisions[i].x > max_x:
            max_x = collisions[i].x
    
    return max_x

func get_min_collision_y(collisions: PoolVector2Array):
    var min_y = null

    for i in range(0,collisions.size()):
        if min_y == null or collisions[i].y < min_y:
            min_y = collisions[i].y
    
    return min_y

func get_max_collision_y(collisions: PoolVector2Array):
    var max_y = null

    for i in range(0,collisions.size()):
        if max_y == null or collisions[i].y > max_y:
            max_y = collisions[i].y
    
    return max_y

func check_walls_collision(entity, offset) -> PoolVector2Array:
    var walls = get_tree().get_nodes_in_group("Walls")
    var results = PoolVector2Array([])

    for wall in walls:
        var intersections: PoolVector2Array = entity._hitbox.intersects(wall._hitbox, offset)
        if intersections.size() > 0:
            results += intersections
            
    
    return results

