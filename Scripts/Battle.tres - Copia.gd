onready var ATTACK = get_node("Interface/Board/Actions/Attack")
onready var DEFENSE = get_node("Interface/Board/Actions/Defense")
onready var SPECIAL = get_node("Interface/Board/Actions/Special")
onready var ITEMS = get_node("Interface/Board/Actions/Items")
onready var RUN = get_node("Interface/Board/Actions/Run")
onready var PLAYER = get_tree().get_root().get_node("Player_stats")
onready var ACT_PLAYER = get_node("Player")
onready var MONSTER = get_node("Monster")

var anim #representa qual animação do player aparece na tela
var active #representa se os turnos estao ativos ou não 
var half #representa meio turno
var turn #contador de quantos turnos se passaram na batalha
var temp_vel #atrasa o carregamento de açao do player
var shader_aux #auxilia trocas de cor do player
#::Player Actions::--------------------------------------------------------------------
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
	pass

func _on_Special_pressed():
	_prepare_player()
	pass

func _on_Items_pressed():
	_prepare_player()
	pass

func _on_Run_pressed():
	get_tree().change_scene("res://Scenes/Mapa_Teste.tscn")
	pass

func _on_Defense_pressed():
	ACT_PLAYER.set_defending(1)
	ACT_PLAYER.set_action("defense")
	temp_vel = 0.5
#::Sistema de dano::--------------------------------------------------------------
#identifica se o valor int eh um monstro ou player alem
#de qual o numero daquele monstro ou player
func identificador(var identificar):
	if (identificar/10 == 1):
		if (identificar == 11):
			return ACT_PLAYER
	elif (identificar/10 == 2):
		if (identificar == 21):
			return MONSTER

#gera dano em um certo personagem
func dano(var atacado,var dano,var status):
	var ATACADO = identificador(atacado)
	var aux = null
	if (status == null):ATACADO.set_color(1)
	else: ATACADO.set_color((ATACADO.get_status()/100)+1)
	
	if (ATACADO == ACT_PLAYER):
		ATACADO = PLAYER
		aux = ACT_PLAYER.get_defending()
		#verifica se o personagem esta defendendo
	else:
		aux = ATACADO.get_defending()
		#verifica se o monstro esta defendendo
	
	ATACADO.set_hp(ATACADO.get_hp() - dano/(1+aux)) #gera o dano
	
	if (ATACADO == PLAYER):ATACADO = ACT_PLAYER
	shader_aux = 0
	if (status != null):
		if (status/1000 != 0 and ATACADO.get_status()/100 == status/1000):
			status = status/10
			var aux = status/100
			var aux3 = 3
			var aux2 = (ATACADO.get_status()%100)/10 + (status%100)/10
			ATACADO.set_status(aux*100+aux2*10+aux3)
		else:
			ATACADO.set_status(status)
	#atualiza os status do personagem apos um dano elemental

#realiza dano elemental em um personagem
#alem de trabalhar com o status para indicar qual o elemento
#do ataque para indicar aos shaders
func dano_status(var ATACADO):
	if (ATACADO.get_status() != 0 and ATACADO.get_status_dmg() == 0):
		var aux2 = ATACADO.get_status()-1
		var aux3 = float(float((aux2%100)/10)/float(100))
		if (aux2 % 10 == 0):
			aux2 = 0
		ATACADO.set_status_dmg(1)
		if (ATACADO == ACT_PLAYER):ATACADO = PLAYER
		dano(11,ATACADO.get_hp_max()*aux3*2,aux2)
#::::--------------------------------------------------------------
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

func _ready():
	anim = ACT_PLAYER.get_action()
	active = 1
	half = 0
	turn = 0
	temp_vel = 1
	shader_aux = -1
	PLAYER.set_st(0)
	set_process(true)

#realiza funçoes em certos pontos de uma animaçao
func _process(delta):
	anim = ACT_PLAYER.get_action()
	if (anim.nocasecmp_to("wait") != 0):
		get_node("Interface/Board/Actions/Defense").set_disabled(true)
		if (anim.nocasecmp_to("attack") == 0 and ACT_PLAYER.get_node("attack").get_frame() == 11):
			dano(21,PLAYER.get_atq(),null)
		elif (anim.nocasecmp_to("off") == 0):
			ACT_PLAYER.set_action("wait")
			active = 1
			get_node("Interface/Board/Actions/Defense").set_disabled(false)

#conta os turnos e realiza os calculos necessarios para
#cada turno passado
func _on_Timer_timeout():
	var aux = 0#usa prum monte de coisas cuidado
	
	if (active == 1):#sistema de turnos ativo
		if (half < 1):#meio turno
			half += 1
			if (shader_aux > -1):shader_aux += 1
		else:#turno completo
			half = 0
			turn += 1
			
			if (PLAYER.get_hp() > 0):
				if (shader_aux > 4):#momento de voltar a cor do player ao original
					ACT_PLAYER.set_color(0)
					shader_aux = -1
				aux = (20+(PLAYER.get_vel())*temp_vel)/10+PLAYER.get_st()#carregamento de açao
				if (aux < 500):
					PLAYER.set_st(aux)
				else:#caso a ação tenha carregado
					temp_vel = 1
					PLAYER.set_st(500)
					ACT_PLAYER.set_defending(0)
					ACT_PLAYER.set_action("wait")
					dano_status(ACT_PLAYER)
					_actions_visibility(true)
			else:
				if (shader_aux > 4):
					ACT_PLAYER.set_color(0)
					shader_aux = -1
			
			if (MONSTER.get_hp() > 0):
				aux = (20+(MONSTER.get_vel())*temp_vel)/10+MONSTER.get_st()
				MONSTER.set_color(0)
				if (aux < 500):
					MONSTER.set_st(aux)
				else:#carregamento de açao completo
					MONSTER.set_st(500)
					dano_status(MONSTER)
					aux = MONSTER.action()
					if (aux == 1):
						if (PLAYER.get_hp() > 0):dano(11,MONSTER.get_atq(),MONSTER.get_atq_el())
						else: _actions_visibility(false)
						MONSTER.set_st(0)
			else:
				ACT_PLAYER.set_color(0)
				get_tree().change_scene("res://Scenes/Mapa_Teste.tscn")
			
			var tam1 = float(float(PLAYER.get_hp())/float(PLAYER.get_hp_max()))
			var tam2 = float(float(PLAYER.get_sp())/float(PLAYER.get_sp_max()))
			var tam3 = float(float(PLAYER.get_st())/float(500))
			_refresh_ui(tam1*100.0,tam2*100.0,tam3*100.0)