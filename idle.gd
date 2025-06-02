extends State
@onready var collision= $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")
@onready var boss_ost = $"../../BoostOst"
@onready var dungeon_ost = owner.get_node("/root/GameLevel/dungeon_Ost")


var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled",value)
		progress_bar.set_deferred("visible",value)
	

func transition():
	if player_entered:
		get_parent().change_state("Follow")


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Playercat":
		player_entered = true
		
		if dungeon_ost.playing:
			dungeon_ost.stop()
			
		if !boss_ost.playing:
			boss_ost.play()


func _ready():
	player_entered = false
	collision.disabled = true
	await get_tree().create_timer(0.1).timeout
	collision.disabled = false
