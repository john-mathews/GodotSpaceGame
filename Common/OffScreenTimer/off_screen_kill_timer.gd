extends VisibleOnScreenNotifier2D

signal killParent
var shouldKillParent := false

@export var killTime := 5

func _ready() -> void:
	kill_timer(killTime*2)
	

func _on_screen_exited() -> void:
	shouldKillParent = true
	kill_timer(killTime)
	
func _on_screen_entered() -> void:
	shouldKillParent = false

func kill_timer(time: int) -> void:
	await get_tree().create_timer(time).timeout
	if (shouldKillParent):
		killParent.emit()
