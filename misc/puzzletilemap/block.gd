extends StaticBody2D
var picked = false
var slashed_sides = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
}

func get_opposite_dir(dir: String) -> String:
	match dir:
		"up": return "down"
		"down": return "up"
		"left": return "right"
		"right": return "left"
	return ""

func apply_cut(side: String):
	if side == "" or slashed_sides[side]:
		return 
	_sever_connection(side)
	
	var area_node = get_node("Areas/" + side)
	var neighbors = area_node.get_overlapping_bodies()
	
	for neighbor in neighbors:
		if neighbor != self and neighbor.is_in_group("blocks"):
			var opposite = get_opposite_dir(side)
			neighbor._sever_connection(opposite)

func _sever_connection(side: String):
	if slashed_sides[side]:
		return
	
	slashed_sides[side] = true
	
	var area_node = get_node("Areas/" + side)
	
	for child in area_node.get_children():
		if child is CollisionShape2D:
			child.debug_color = Color(1.0, 0.0, 0.0, 0.6)
