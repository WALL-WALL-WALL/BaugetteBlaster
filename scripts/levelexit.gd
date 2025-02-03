extends CharacterBody2D


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var level_name = "res://level" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(level_name)
	if (next_level_number == 4):
		get_tree().quit()
