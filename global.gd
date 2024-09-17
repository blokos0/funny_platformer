extends Node
var leveldata: Dictionary = {
	"tiles" = ""
}
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart()
func restart() -> void:
	get_tree().reload_current_scene.call_deferred()
