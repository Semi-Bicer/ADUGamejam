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
	# 1. Kendi yüzeyimizi kes ve rengini değiştir
	_sever_connection(side)
	# 2. Komşuyu bul ve onun bağını da çift taraflı kopar
	var area_node = get_node("Areas/" + side)
	var opposite_side = get_opposite_dir(side)
	
	var overlaps = area_node.get_overlapping_bodies()
	for overlap in overlaps:
		if overlap != self and overlap.is_in_group("blocks"):
			# Komşunun sadece kendi yüzeyini kesmesini sağla (Sonsuz döngüyü engeller)
			overlap._sever_connection(opposite_side)

func _sever_connection(side: String):
	if slashed_sides[side]:
		return
	
	slashed_sides[side] = true
	
	var area_node = get_node("Areas/" + side)
	
	for child in area_node.get_children():
		if child is CollisionShape2D:
			child.debug_color = Color(1.0, 0.0, 0.0, 0.6)
