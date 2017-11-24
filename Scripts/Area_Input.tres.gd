#Area generica que reage ao jogador

var dentro

func _ready():
	dentro = 0
	set_process_input(true)

func _on_Area2D_body_enter( body ):
	if (body.has_method("wanted_body")):dentro = 1

func _on_Area2D_body_exit( body ):
	dentro = 0

func _input(event):
	if (Input.is_action_pressed("ui_accept") and dentro == 1):
		dentro = 0
		print ("estou aqui")