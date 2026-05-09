extends Node2D
var isWave =false

func _process(delta: float) -> void:
	if !isWave:
		_random(5)
		isWave = true
	 

func _random(sayi:int):
	return randi()%sayi +1
