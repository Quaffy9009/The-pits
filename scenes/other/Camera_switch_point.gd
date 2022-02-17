extends Area2D

export var enabled = true
export (NodePath) var current_camera
export (NodePath) var player
export (NodePath) var next_point
export (NodePath) var prev_point
export var vertical = true

export var camera_left_exist = false
export var camera_right_exist = false

export var current_camera_left = false
export var current_camera_right = false

export var one_time_pass = false


func _on_Area2D_body_entered(body):
	if enabled:
		if one_time_pass and body.is_in_group("player"):
			$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
			
		if camera_left_exist and current_camera_right:
			if body.is_in_group("player"):
				#get_node(switch_to_left).current = true
				#current_camera = switch_to_left
				#get_node(player).get_node("RemoteTransform2D").set_remote_node(switch_to_left)
				current_camera_left = true
				current_camera_right = false
				if vertical:
					get_node(current_camera).limit_right = $camera_limit.global_position.x
					if prev_point and get_node(prev_point).vertical:
						get_node(current_camera).limit_left = get_node(next_point).get_node("camera_limit").global_position.x
					else: get_node(current_camera).limit_left = -10000000
				$StaticBodyRight/CollisionShape2D.set_deferred("disabled", false)
		
		elif camera_right_exist and current_camera_left:
			if body.is_in_group("player"):
				#print(get_node(next_point).vertical)
				#get_node(switch_to_right).current = true
				#current_camera = switch_to_right
				#get_node(player).get_node("RemoteTransform2D").set_remote_node(switch_to_right)
				current_camera_left = false
				current_camera_right = true
				if vertical:
					get_node(current_camera).limit_left = $camera_limit.global_position.x
					if next_point and get_node(next_point).vertical:
						get_node(current_camera).limit_right = get_node(next_point).get_node("camera_limit").global_position.x
						
					else: get_node(current_camera).limit_right = 1000000
				$StaticBodyLeft/CollisionShape2D.set_deferred("disabled", false)
	


func _on_Area2D_body_exited(body):
	if !one_time_pass and body.is_in_group("player"):
		$StaticBodyRight/CollisionShape2D.set_deferred("disabled", true)
		$StaticBodyLeft/CollisionShape2D.set_deferred("disabled", true)

func _ready():
	if current_camera_left:
		get_node(current_camera).limit_right = 81
		
	#elif current_camera_right:
	#	get_node(current_camera).limit_left = $camera_limit.global_position.x


