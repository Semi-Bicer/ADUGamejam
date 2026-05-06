extends Area2D
@onready var collider: CollisionObject2D = $CollisionShape2Dvar 
var is_filled: bool = false
var names: Array



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	for i in get_overlapping_bodies():
		names.push_back(i.name)
	
	for i in names:
		if "block" in i:
			is_filled = true
			break
		is_filled = false
	
	
