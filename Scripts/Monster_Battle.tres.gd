onready var MONSTER = self

var xp_gain
var hp
var hp_max
var sp
var sp_max
var st
var atq
var vel
var foco
var status
var status_dmg
var color
var shader_Sprite

func xp_gain():
	return xp_gain

func get_hp():
	return hp

func set_hp(var new):
	hp = new
	get_node("HP").refresh(float(float(hp)*100.0/float(hp_max)))
	if (hp > hp_max):
		hp = hp_max
	elif (hp < 0):
		hp = 0

func get_hp_max():
	return hp_max

func set_hp_max(var new):
	hp_max = new

func get_sp():
	return sp

func set_sp(var new):
	sp = new
	if (sp > sp_max):
		sp = sp_max
	elif (sp < 0):
		sp = 0

func get_sp_max():
	return sp_max

func set_sp_max(var new):
	sp_max = new

func get_st():
	return st

func set_st(var new):
	st = new
	if (st > 500):
		st = 500
	elif (st < 0):
		st = 0

func get_atq():
	return atq

func set_atq(var new):
	atq = new

func get_atq_el():
	if (randi()%101<31):
		var el = ((randi()%3)+1)*100
		el += ((randi()%5)+1)*10
		el += (randi()%5)+1
		return el
	else: return null

func get_vel():
	return vel

func set_vel(var new):
	vel = new

func get_foco():
	return foco

func set_foco(var new):
	foco = new

func action():
	return 1

func get_status():
	return status

func set_status(var new):
	status = new

func get_status_dmg():
	return status_dmg

func set_status_dmg(var new):
	status_dmg = new

#gera dano em um certo personagem
func dano(var dano,var status):
	var ATACADO = self
	var aux = null
	if (status == null):ATACADO.set_color(1)
	else: ATACADO.set_color((ATACADO.get_status()/100)+1)
	ATACADO.set_hp(ATACADO.get_hp() - dano) #gera o dano
	
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
		dano(ATACADO.get_hp_max()*aux3*2,aux2)

func get_color():
	return color

func set_color(var new):
	color = new
	shader_Sprite.set_shader_param("ativar",new)

func turn():
	if (hp > 0):
		MONSTER.set_color(0)
		if(get_st() == 500):
			MONSTER.dano_status()

func _ready():
	xp_gain = 30
	hp_max = 500
	self.set_hp(500)
	sp = 100
	sp_max = 100
	st = 0
	atq = 50
	vel = 10
	foco = 1
	status = 0
	status_dmg = 0
	color = 1
	shader_Sprite = get_node("Sprite").get_material()
	randomize()