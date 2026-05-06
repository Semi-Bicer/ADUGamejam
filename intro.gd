extends Node2D
var limit = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Intro1.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if limit == 0:
			limit = 1
		elif limit ==1:
			$AnimationPlayer.play("fade")
			limit = 2
		elif limit == 3 and !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("fade2")
			limit = 4
	if limit ==2 and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("rising2")
		limit = 3
	if limit == 4 and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("rising3")
		limit = 5
