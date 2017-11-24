onready var ATTACK = get_node("Interface/Board/Actions/Attack")
onready var DEFENSE = get_node("Interface/Board/Actions/Defense")
onready var SPECIAL = get_node("Interface/Board/Actions/Special")
onready var ITEMS = get_node("Interface/Board/Actions/Items")
onready var RUN = get_node("Interface/Board/Actions/Run")
onready var PLAYER = get_tree().get_root().get_node("Player_stats")
onready var ACT_PLAYER = get_node("Player")
onready var EQUIPS = get_tree().get_root().get_node("Items_Equips")
onready var SPECIALS_DATA = get_tree().get_root().get_node("Special_attacks")
onready var MONSTER = get_node("Monster")

var anim #representa qual animação do player aparece na tela
var active #representa se os turnos estao ativos ou não 
var half #representa meio turno
var turn #contador de quantos turnos se passaram na batalha
var temp_vel #atrasa o carregamento de açao do player
#::Actions::--------------------------------------------------------------------
#visibilidade da interface
func _actions_visibility(var boolean):
	ATTACK.set_hidden(!boolean)
	DEFENSE.set_hidden(boolean)
	SPECIAL.set_hidden(!boolean)
	ITEMS.set_hidden(!boolean)
	RUN.set_hidden(!boolean)

#prepara jogador para o proximo carregamento de açao
func _prepare_player():
	_actions_visibility(false)
	PLAYER.set_st(0)
	ACT_PLAYER.set_status_dmg(0)
	ACT_PLAYER.set_defending(0)

func _on_Attack_pressed():
	_prepare_player()
	ACT_PLAYER.set_action("attack")
	active = 0

func _on_Special_pressed():
	SPECIALS_DATA.special(PLAYER.get_specials(0))
	var sp_loss = SPECIALS_DATA.get_mov_cost()
	if (PLAYER.get_sp()>=sp_loss):
		_prepare_player()
		ACT_PLAYER.set_action("special1")
		PLAYER.set_sp(PLAYER.get_sp()-sp_loss)
		active = 0
	else:
		SPECIAL.set_disabled(true)
		SPECIAL.set_disabled(false)

func _on_Items_pressed():
	_prepare_player()

func _on_Run_pressed():
	if (PLAYER.get_hp()>0):
		get_tree().change_scene("res://Scenes/Mapa_Teste.tscn")
	_prepare_player()

func _on_Defense_pressed():
	ACT_PLAYER.set_defending(1)
	ACT_PLAYER.set_action("defense")
	temp_vel = 0.5

#::Visuals::---------------------------------------------------------------

func get_PLAYER():
	return PLAYER

func _refresh_ui(var a, var b, var c):
	get_node("Interface/Board/HP").refresh(a)
	get_node("Interface/Board/SP").refresh(b)
	get_node("Interface/Board/ST").refresh(c)
	if(ACT_PLAYER.get_status()/100 == 1):
		get_node("Interface/Board/Fire").set_hidden(false)
	elif(ACT_PLAYER.get_status()/100 == 2):
		get_node("Interface/Board/Ice").set_hidden(false)
	elif(ACT_PLAYER.get_status()/100 == 3):
		get_node("Interface/Board/Lightning").set_hidden(false)
	else:
		get_node("Interface/Board/Fire").set_hidden(true)
		get_node("Interface/Board/Ice").set_hidden(true)
		get_node("Interface/Board/Lightning").set_hidden(true)

#realiza funçoes em certos pontos de uma animaçao
func _process(delta):
	anim = ACT_PLAYER.get_action()
	if (anim.nocasecmp_to("wait") != 0):
		get_node("Interface/Board/Actions/Defense").set_disabled(true)
		if (anim.nocasecmp_to("attack") == 0 and ACT_PLAYER.get_node("attack").get_frame() == 11):
			MONSTER.dano(PLAYER.get_atq(),PLAYER.get_el_atq())
		elif (anim.nocasecmp_to("special1") == 0 and ACT_PLAYER.get_node("attack").get_frame() == 11):
			SPECIALS_DATA.special(PLAYER.get_specials(0))
			MONSTER.dano(PLAYER.get_atq()*SPECIALS_DATA.get_mov_mult(),PLAYER.get_el_atq())
		elif (anim.nocasecmp_to("off") == 0):
			ACT_PLAYER.set_action("wait")
			active = 1
			get_node("Interface/Board/Actions/Defense").set_disabled(false)

#::Active System::----------------------------------------------------------

#conta os turnos e realiza os calculos necessarios para
#cada turno passado
func _on_Timer_timeout():
	var aux = 0#usa prum monte de coisas cuidado
	
	if (active == 1):#sistema de turnos ativo
		if (half < 1):#meio turno
			half += 1
			if (PLAYER.get_shader_color() > -1):
				PLAYER.set_shader_color(PLAYER.get_shader_color()+1)
		else:#turno completo
			half = 0
			turn += 1
			
			if (PLAYER.get_hp() > 0):
				aux = (20+(PLAYER.get_vel())*temp_vel)/10+PLAYER.get_st()
				PLAYER.set_st(aux)#carregamento de açao
				if (PLAYER.get_st() == 500):#caso a ação tenha carregado
					temp_vel = 1
					_actions_visibility(true)
			ACT_PLAYER.turn()
			
			if (MONSTER.get_hp() > 0):
				aux = (20+(MONSTER.get_vel())*temp_vel)/10+MONSTER.get_st()
				MONSTER.set_st(aux)
				if(aux >= 500):#carregamento de açao completo
					aux = MONSTER.action()
					if (aux == 1):
						if (PLAYER.get_hp() > 0):ACT_PLAYER.dano(MONSTER.get_atq(),MONSTER.get_atq_el())
						else: _actions_visibility(false)
						MONSTER.set_st(0)
			else:
				PLAYER.set_xp(PLAYER.get_xp()+MONSTER.xp_gain())
				print("lvl="+str(PLAYER.get_lvl()))
				print("lvl_xp="+str(PLAYER.get_lvl_xp()))
				print("xp="+str(PLAYER.get_xp()))
				ACT_PLAYER.set_color(0)
				get_tree().change_scene("res://Scenes/Mapa_Teste.tscn")
			MONSTER.turn()
			
			var tam1 = float(float(PLAYER.get_hp())/float(PLAYER.get_hp_max()))
			var tam2 = float(float(PLAYER.get_sp())/float(PLAYER.get_sp_max()))
			var tam3 = float(float(PLAYER.get_st())/float(500))
			_refresh_ui(tam1*100.0,tam2*100.0,tam3*100.0)

func _ready():
	anim = ACT_PLAYER.get_action()
	active = 1
	half = 0
	turn = 0
	temp_vel = 1
	PLAYER.set_st(0)
	set_process(true)
