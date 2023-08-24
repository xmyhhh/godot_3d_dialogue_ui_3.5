extends Spatial

export(NodePath) var dialog_box
export(NodePath) var player_node
var test_data = [
	{
		'name': "Mr.Dot",
		'content':"dsadasfas asdasdas fsad a  dasd ffa saa !!",
		'end':"..."

	},
	{
		'name': "Mr.Dotasasad",
		'content':" 三千年前，神明降临。仙、神决战致天地大灾变。灵气衰弱，仙人消失，神明却重新渗透人间；一百六十多年前，异宝降临。富饶的赤帕高原、战无不胜的盘龙古城，尽数化为黄土；如今，我，降临了！追寻仙人留下的线索，扭转既定的宿命，解开仙魔的真相……",
		'end':"..."
	},
	{
		'name': "Mr",
		'content':"ok!",
		'end':"..."
	}
]

func _ready():
	dialog_box = get_node(dialog_box)
	player_node = get_node(player_node)
	
func test1():

	dialog_box.set_top(test_data[0]["name"])
	dialog_box.set_center(test_data[0]["content"])
	dialog_box.set_buttom(test_data[0]["end"])

func test2():
	dialog_box.set_top(test_data[1]["name"])
	dialog_box.set_center(test_data[1]["content"])
	dialog_box.set_buttom(test_data[1]["end"])

func test3():
	dialog_box.set_top(test_data[2]["name"])
	dialog_box.set_center(test_data[2]["content"])
	dialog_box.set_buttom(test_data[2]["end"])

func player_move():
	player_node.transform.origin.x += 0.5



