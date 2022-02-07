extends Area2D

export (NodePath) var current_camera
export (NodePath) var switch_to_left
export (NodePath) var switch_to_right
export (NodePath) var player
export var one_time_pass = false



func _on_Area2D_body_entered(body):
	if switch_to_left:
		if body.is_in_group("player"):
			get_node(switch_to_left).current = true
			current_camera = switch_to_left
	
	if switch_to_right:
		if body.is_in_group("player"):
			get_node(switch_to_right).current = true
			current_camera = switch_to_right
	if one_time_pass:
		$StaticBody2D/CollisionShape2D2.disabled = false
