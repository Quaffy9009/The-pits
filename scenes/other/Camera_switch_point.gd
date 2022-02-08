extends Area2D

export (NodePath) var current_camera
export (NodePath) var switch_to_left
export (NodePath) var switch_to_right
export (NodePath) var player
export var vertical = true

export var one_time_pass = false


func _on_Area2D_body_entered(body):
	if one_time_pass and body.is_in_group("player"):
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		print("S")
	if switch_to_left and current_camera == switch_to_right:
		if body.is_in_group("player"):
			get_node(switch_to_left).current = true
			#get_node(current_camera).current = false
			current_camera = switch_to_left
			get_node(player).get_node("RemoteTransform2D").set_remote_node(switch_to_left)
	
	elif switch_to_right and current_camera == switch_to_left:
		if body.is_in_group("player"):
			#get_node(current_camera).current = false
			get_node(switch_to_right).current = true
			current_camera = switch_to_right
			get_node(player).get_node("RemoteTransform2D").set_remote_node(switch_to_right)
	


func _on_Area2D_body_exited(body):
	pass

func _process(delta):
	if vertical:
		get_node(switch_to_left).limit_right = $camera_limit_right.global_position.x
		get_node(switch_to_right).limit_left = $camera_limit_left.global_position.x




