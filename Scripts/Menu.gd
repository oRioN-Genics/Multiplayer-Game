extends Control


func _on_host_game_pressed() -> void:
	$".".visible = false
	MultiplayerManager.become_host()


func _on_join_player_pressed() -> void:
	print("Join as player 2")
	$".".visible = false
	MultiplayerManager.join_as_player_2()


func _on_quit_pressed() -> void:
	get_tree().quit()
	
