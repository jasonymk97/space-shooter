extends Control

@export var level_scene: PackedScene

func _ready() -> void:
	$CenterContainer/VBoxContainer/Label2.text += str(Global.score)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot'):
		get_tree().change_scene_to_packed(level_scene)
