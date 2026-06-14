extends Area2D

func _ready() -> void:
	pass
	#Временно
	#hide()
	#$CollisionShape2D.set_deferred("disabled", true)



func _process(delta: float) -> void:
	pass


func clear_all_bonuses():
	var bonuses = get_tree().get_nodes_in_group("bonuses")
	for bonus in bonuses:
		if is_instance_valid(bonus):
			bonus.queue_free()
