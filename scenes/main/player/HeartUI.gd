extends Node2D


func _process(delta):
	if get_parent().get_parent().get_node(".").health == 6:
		$Hearts3.show()
	elif get_parent().get_parent().get_node(".").health == 5:
		$Hearts3.hide()
		$HHearts2.show()
	elif get_parent().get_parent().get_node(".").health == 4:
		$Hearts3.hide()
		$HHearts2.hide()
		$Hearts2.show()
	elif get_parent().get_parent().get_node(".").health == 3:
		$Hearts3.hide()
		$HHearts2.hide()
		$Hearts2.hide()
		$HHearts1.show()
	elif get_parent().get_parent().get_node(".").health == 2:
		$Hearts3.hide()
		$HHearts2.hide()
		$Hearts2.hide()
		$HHearts1.hide()
		$Hearts1.show()
	elif get_parent().get_parent().get_node(".").health == 1:
		$Hearts3.hide()
		$HHearts2.hide()
		$Hearts2.hide()
		$HHearts1.hide()
		$Hearts1.hide()
		$HHearts.show()
	else:
		$Hearts3.hide()
		$HHearts2.hide()
		$Hearts2.hide()
		$HHearts1.hide()
		$Hearts1.hide()
		$HHearts.hide()
		$Hearts0.show()
		Global.shell_amount = 0
		get_tree().change_scene("res://scenes/main/levels/level1/Level1.tscn")
		Global.health = 6
		Global.died()
