extends Node

class MovementResponse:
    var displacement: Vector2 = Vector2.ZERO
    var collisions: Array = []

class CollisionResponseValue:
    var hitbox: PolygonHitBox
    var collision_polygon: PoolVector2Array = []

    func _init(init_hitbox: PolygonHitBox, init_collision_polygon: PoolVector2Array):
        self.hitbox = init_hitbox
        self.collision_polygon = init_collision_polygon



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

func check_collisions(entity: Node2D , offset: Vector2, group_to_check: String, print_log: bool = false) -> Array:
    var nodes_to_check = get_tree().get_nodes_in_group(group_to_check)
    var results = []

    for node in nodes_to_check:
        var intersections: PoolVector2Array = entity._hitbox.intersects(node._hitbox, offset, print_log)
        if intersections.size() > 0:
            results.append(CollisionResponseValue.new(node._hitbox, intersections))
    
    return results
