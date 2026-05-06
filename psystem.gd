extends Node2D

var derece = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_select"):
		derece += delta
	if derece > 0.5:
		for part in get_children():
			part.amount += 1
		derece = 0
	print($CPUParticles2D.amount)
	
	
