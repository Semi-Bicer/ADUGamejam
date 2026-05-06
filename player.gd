extends CharacterBody2D
const multiplier = 1
const pickBoxDistance = 108 # sebebi çözünürlüğün katı 
const tile_size: Vector2 = Vector2(108* multiplier, 108* multiplier)
var sprite_node_pos_tween: Tween
@onready var pickBox: Area2D = $pickBox
var equip = false
var timer = 0 
var timer_condition = false
var names : Array
var picked = false
var grabbed_cluster: Array = [] # şuan taşınan block/ bıçak
var last_dir
@onready var animated_sprite = $AnimatedSprite2D



func _physics_process(delta: float) -> void:
	if timer_condition:
		timer += delta
	if timer >0.2:
		pickBox.visible = false
		timer = 0
		timer_condition = false
	
	if Input.is_action_just_pressed("ui_select"):
		timer_condition = true
		pickBox.visible=true
		if pickBox.has_overlapping_bodies():
			for i in pickBox.get_overlapping_bodies():
				if i.name == "Knife":
					grab_release(i)
					break
				elif "block" in i.name:
					grab_release(i)
					break
		else:
			grab_release(null)
	
	if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
		if Input.is_action_pressed("ui_up") and !$up.is_colliding():
			_move(Vector2(0, -1))
			animated_sprite.play("anim_up")
		if Input.is_action_pressed("ui_down") and !$down.is_colliding():
			_move(Vector2(0, 1))
			animated_sprite.play("anim_down")
		if Input.is_action_pressed("ui_left") and !$left.is_colliding():
			_move(Vector2(-1,0))
			animated_sprite.play("anim_side")
			animated_sprite.flip_h = true
		if Input.is_action_pressed("ui_right") and !$right.is_colliding():
			_move(Vector2(1, 0))
			animated_sprite.play("anim_side")
			$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("slash_action"):
		perform_slash()


func _move(dir: Vector2):
	global_position += dir * tile_size
	pickBox.global_position =global_position + dir * pickBoxDistance
	$AnimatedSprite2D.global_position -= dir * tile_size
	last_dir = dir
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($AnimatedSprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)	
	



func get_all_connected_blocks(start_block: StaticBody2D, list: Array = []) -> Array:
	if start_block in list:
		return list
	
	list.append(start_block)
	var areas = start_block.get_node("Areas")
	for area in areas.get_children():
		var direction = area.name
		if start_block.slashed_sides[direction]:
			continue
		
		var overlaps = area.get_overlapping_bodies()
		for overlap in overlaps:
			if overlap != start_block and overlap.is_in_group("blocks"):
				var opposite_dir = get_opposite_dir(direction)
				if !overlap.slashed_sides[opposite_dir]:
					get_all_connected_blocks(overlap, list)
			
			
	
	return list	
	
func get_opposite_dir(dir: String) -> String:
	match dir:
		"up": return "down"
		"down": return "up"
		"left": return "right"
		"right": return "left"
	return ""
	
func grab_release(body: Node):
	if  grabbed_cluster.is_empty():	 #grab
		if body != null:
			if body.is_in_group("knife"):
				body.reparent($InventoryPivot, true)
				grabbed_cluster = [body]
				return
			elif body.is_in_group("blocks"):
				
				grabbed_cluster = get_all_connected_blocks(body)
			
			for item in grabbed_cluster:
				item.reparent($InventoryPivot, true)
				item.modulate.a = 0.5
				# Fizik çakışmalarını kapat
				if item.has_node("CollisionShape2D"):
					item.get_node("CollisionShape2D").disabled = true
				
				item.picked = true
	else:# release
		var world_node = get_parent()
		print("Blok bırakıldı")
		if body != null:
			if body.is_in_group("Knife"):
				body.reparent(get_parent(),true)
		var tilemap = world_node.get_node("TileMapLayer")
		for item in grabbed_cluster:
			if item.is_in_group("knife"):
				item.reparent(world_node, true)
				break
			item.reparent(world_node, true)
			
			var local_pos = tilemap.to_local(item.global_position)
			var map_cell = tilemap.local_to_map(local_pos)
			var snapped_local_pos = tilemap.map_to_local(map_cell)
			item.global_position = tilemap.to_global(snapped_local_pos)
			
			item.picked = false
			item.modulate.a = 1
			
			if item.has_node("CollisionShape2D"):
				item.get_node("CollisionShape2D").disabled = false 
				
		grabbed_cluster = []
			

func perform_slash():
	var has_knife = false
	for item in grabbed_cluster:
		if item.is_in_group("knife"):
			has_knife = true
			break
	if !has_knife:
		return
	
	var overlaps = pickBox.get_overlapping_bodies()
	  
	for body in overlaps:
		if body.is_in_group("blocks"):
			var target_side = get_slash_target_side(last_dir)
			if target_side != "":
				body.apply_cut(target_side)
				print("Kesilen yön: ", target_side)
			
func get_slash_target_side(dir: Vector2) -> String:
	match dir:
		Vector2.RIGHT: return "down"	
		Vector2.DOWN:  return "left"
		Vector2.LEFT:  return "down"
		Vector2.UP:    return "right"
	return ""
