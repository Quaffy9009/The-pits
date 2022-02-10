extends Area2D

export(int) var level
export(Vector2) var last_position 


func _on_Checkpoint_body_entered(body):
	Global.last_position = last_position
	
