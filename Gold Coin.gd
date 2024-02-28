extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		
		#Create tween: animation for picking up coins
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		#Change position of the gold coin by position for '1' second
		tween.tween_property(self, "position", position - Vector2(0, 30), 0.4)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		
		tween.tween_callback(queue_free)
		
		Game.Gold += 1
