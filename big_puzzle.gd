extends Node2D

var resolved = false

func _process(delta: float) -> void:
	if get_children() != null:
		for i in get_children():
			if !i.is_filled:
				resolved = false
				break
			resolved=true
	
