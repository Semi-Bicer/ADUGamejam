extends Control
@onready var timer = $Timer
@onready var text = $MarginContainer/MarginContainer/HBoxContainer/Label
# Called when the node enters the scene tree for the first time.
var seq = 0
func _ready() -> void:
	self.hide()
	clear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func clear():
	if text.text.length()>0:
		text.text = ""

func typing(sequence):
	if sequence == 4:
		queue_free()
	var sentence = ["Bos duvarlari izlerken, aynalarla aran bozukken...
","Aynalarin ardinda yine sen, hayaller kurardin...
","Sonunda fark ettin, ama gordugundu gercek dusmanin..."]
	
	for i in sentence[sequence].length():
		text.text += sentence[sequence][i]
	
		var delay = 0.03
		timer.stop()
		timer.wait_time = delay
		timer.one_shot = true
		timer.start()
		await timer.timeout

func _input(event: InputEvent) -> void:
	if seq>2:
		seq=0

	if event.is_action_pressed("space"):
		self.show()
		clear()
		typing(seq)
		seq += 1
	
