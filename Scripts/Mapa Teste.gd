onready var PLAYER = get_tree().get_root().get_node("Player_stats")
onready var ACT_PLAYER = get_node("YSort/Player_body")
onready var EQUIPS = get_tree().get_root().get_node("Items_Equips")
onready var ie_up = Input.is_action_pressed("ui_up")
onready var ie_down = Input.is_action_pressed("ui_down")
onready var ie_left = Input.is_action_pressed("ui_left")
onready var ie_right = Input.is_action_pressed("ui_right")
onready var ie_cancel = Input.is_action_pressed("ui_cancel")
onready var board = get_node("Menu/Board")

var screen_size
var map_size
var count

func _ready():
	screen_size = get_viewport_rect().size
	ACT_PLAYER.set_pos(Vector2(PLAYER.get_pos_x(),PLAYER.get_pos_y()))
	count = 0
	set_process_input(true)

func _input(event):
	if(Input.is_action_pressed("ui_cancel")):
		if (board.is_hidden()):
			board.set_hidden(false)
			board.get_node("Menu1").set_hidden(false)
			ACT_PLAYER.set_active(0)
		else:
			if(board.get_node("Menu2").is_hidden() and board.get_node("Menu3").is_hidden()):
				board.set_hidden(true)
				ACT_PLAYER.set_active(1)
			elif(not board.get_node("Menu3").is_hidden()):
				board.get_node("Menu3").set_hidden(true)
				board.get_node("Menu1").set_hidden(false)
			elif(not board.get_node("Menu2").is_hidden()):
				board.get_node("Menu2").set_hidden(true)
				board.get_node("Menu1").set_hidden(false)

func _on_Botao1_pressed():
	board.set_hidden(true)
	board.get_node("Menu3").set_hidden(true)
	board.get_node("Menu2").set_hidden(true)
	board.get_node("Menu1").set_hidden(false)
	ACT_PLAYER.set_active(1)

func _on_Botao2_pressed():
	board.get_node("Menu1").set_hidden(true)
	board.get_node("Menu2").set_hidden(false)
	board.get_node("Menu2/Player1").refresh()
	PLAYER.refresh_equips()
	var watq = EQUIPS.get_atq()
	var wel_atq = EQUIPS.get_el_atq()
	var wfoco = EQUIPS.get_foco()
	var wvel = EQUIPS.get_vel()
	board.get_node("Menu1/Botao2").set_disabled(true)
	board.get_node("Menu1/Botao2").set_disabled(false)

func _on_Botao3_pressed():
	board.get_node("Menu1").set_hidden(true)
	board.get_node("Menu3").set_hidden(false)
	board.get_node("Menu3/Player1").refresh()
	PLAYER.refresh_equips()
	var watq = EQUIPS.get_atq()
	var wel_atq = EQUIPS.get_el_atq()
	var wfoco = EQUIPS.get_foco()
	var wvel = EQUIPS.get_vel()
	board.get_node("Menu1/Botao3").set_disabled(true)
	board.get_node("Menu1/Botao3").set_disabled(false)

func _on_Botao4_pressed():
	pass # replace with function body
