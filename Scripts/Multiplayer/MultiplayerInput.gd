extends MultiplayerSynchronizer

@export var input_direction = Vector2.ZERO


func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
