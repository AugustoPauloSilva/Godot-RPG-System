onready var PLAYER = get_tree().get_root().get_node("Player_stats")
onready var ACT_PLAYER = self

var status
var status_dmg
var defending
var color
var shader_Wait
var action

func get_status():
	return status

func set_status(var new):
	status = new

func get_status_dmg():
	return status_dmg

func set_status_dmg(var new):
	status_dmg = new

func get_defending():
	return defending

func set_defending(var new):
	defending = new

#gera dano em um certo personagem
func dano(var dano,var status):
	var ATACADO = get_tree().get_root().get_node("Player_stats")
	var aux = get_defending()#verifica se o personagem esta defendendo
	ATACADO.set_hp(ATACADO.get_hp() - dano/(1+aux)) #gera o dano
	ATACADO.set_shader_color(0)
	
	ATACADO = self
	var aux = null
	if (status == null):ATACADO.set_color(1)
	else: ATACADO.set_color((ATACADO.get_status()/100)+1)
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
func dano_status():
	var ATACADO = self
	if (ATACADO.get_status() != 0 and ATACADO.get_status_dmg() == 0):
		var aux2 = ATACADO.get_status()-1
		var aux3 = float(float((aux2%100)/10)/float(100))
		if (aux2 % 10 == 0):
			aux2 = 0
		ATACADO.set_status_dmg(1)
		ATACADO = get_tree().get_root().get_node("Player_stats")
		dano(ATACADO.get_hp_max()*aux3*2,aux2)

func get_color():
	return color

func set_color(var new):
	color = new
	shader_Wait.set_shader_param("ativar",new)

func get_action():
	return action

#seta action e ja prepara os mostra o sprite necessario para
#aquela ação
func set_action(var new):
	action = new
	var ACTION = null
	if (action.nocasecmp_to("defense") == 0):ACTION = get_node("defense")
	elif (action.nocasecmp_to("attack") == 0):ACTION = get_node("attack")
	elif (action.nocasecmp_to("special1") == 0):ACTION = get_node("attack")
	else:ACTION = get_node("wait")
	
	_hidden()
	if (action.nocasecmp_to("off") != 0):
		ACTION.set_hidden(false)
		if(action.nocasecmp_to("defense") != 0 and not ACTION.is_playing()):
			ACTION.set_frame(0)
			ACTION.play()

#Esconde os sprites
func _hidden():
	get_node("attack").set_hidden(true)
	get_node("defense").set_hidden(true)
	get_node("wait").set_hidden(true)

#lida com o final de uma animaçao
func _process(delta):
	if(get_node("attack").is_playing()):
		if (get_node("attack").get_frame() == 19):
			get_node("attack").stop()
			set_action("off")

func turn():
	if (PLAYER.get_hp() > 0):
		if (PLAYER.get_shader_color() > 4):#momento de voltar a cor do player ao original
			ACT_PLAYER.set_color(0)
			PLAYER.set_shader_color(-1)
		if (PLAYER.get_st() == 500):
			set_defending(0)
			set_action("wait")
			dano_status()
	else:
		if (PLAYER.get_shader_color() > 4):
			ACT_PLAYER.set_color(0)
			PLAYER.set_shader_color(-1)

func _ready():
	status = 0
	status_dmg = 0
	defending = 0
	color = 0
	shader_Wait = get_node("wait").get_material()
	set_action("wait")
	randomize()
	set_process(true)
