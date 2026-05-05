extends StaticBody2D
var picked = false
var slashed_sides = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
}

func slashed(direction: String):
	slashed_sides[direction] = true
	return




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
