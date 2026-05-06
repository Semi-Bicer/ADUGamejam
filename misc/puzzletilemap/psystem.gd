extends Node2D

@onready var particle_nodes = [$CPUParticles2D, $CPUParticles2D2, $CPUParticles2D3, $CPUParticles2D4]

@export var fade_speed = 1.5      
@export var fill_threshold = 0.95 

func _ready():
	for particle in particle_nodes:
		particle.modulate.a = 0.1
		particle.preprocess = 2.0 

func _process(delta: float) -> void:
	var target_alpha: float = 0.0
	
	if Input.is_action_pressed("ui_select"):
		target_alpha = 1.0
	else:
		target_alpha = 0.1
	for particle in particle_nodes:
		particle.modulate.a = lerp(particle.modulate.a, target_alpha, fade_speed * delta)
		
		if particle.modulate.a >= fill_threshold:
			complete_transition()

func complete_transition():
	set_process(false)
	print("Ekran tamamen kaplandı, sahne değişiyor...")
	print("Ekran doldu, sahne değişiyor...")
