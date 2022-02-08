extends Camera2D


func _ready():
	pass


func _on_Player_grounded_updated(is_grounded):
	drag_margin_v_enabled = !is_grounded
