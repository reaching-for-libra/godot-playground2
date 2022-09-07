extends Node


func check_walls_collision(entity, offset) -> bool:
    var walls = get_tree().get_nodes_in_group("Walls")

    for wall in walls:
        if entity._hitbox.intersects2(wall._hitbox, offset):
            return true;
    
    return false

