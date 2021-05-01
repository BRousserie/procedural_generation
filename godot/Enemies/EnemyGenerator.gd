extends Node
class_name EnemyGenerator

  
var result: Array
var difficulty: int
  
var masks := [
	[[1,1,1],[1,1,1],[1,1,1]],
	[[1,1,0],[0,1,1],[0,0,0]]
  ];

var map: Array #<Square>
  
var current_size := 0
var count := 1
var rng
var possiOnBorder : Array
  
func _init():
	rng = RandomNumberGenerator.new()
	#this.map = new Square[4][4];
	for i in range (4):
		map.append([])
	#	print("Ok !")
	
	
	for i in range(map.size()):
		for j in range(map.size()):
			map[i].append(Square.new(i*4 + j, 0))
		
	
	
	map[0][1].sides[2][1] = 1
	map[0][2].sides[0][1] = 1
	
	
	map[1][0].sides[1][1] = 1
	map[1][1].sides[0][1] = 1
	map[1][1].sides[1][1] = 1
	map[1][1].sides[2][1] = 1
	map[1][1].sides[3][1] = 1
	map[1][2].sides[3][1] = 1
	
	map[2][0].sides[0][1] = 1
	map[2][0].sides[2][1] = 1
	map[2][1].sides[1][1] = 1
	map[2][1].sides[3][1] = 1
	"""
	map[2][2].sides[0][0] = -1
	map[2][2].sides[0][1] = -1
	map[2][2].sides[0][2] = -1
	map[2][2].sides[0][0] = -1
	map[2][2].sides[1][1] = -1
	map[2][2].sides[1][2] = -1
	map[2][2].sides[2][0] = -1
	map[2][2].sides[2][1] = -1
	map[2][2].sides[2][2] = -1
	map[2][2].sides[3][0] = -1
	map[2][2].sides[3][1] = -1
	map[2][2].sides[3][2] = -1
	"""
	map[3][0].sides[0][1] = 1
	map[3][0].sides[1][1] = 1
	
	map[3][1].sides[1][1] = 1
	map[3][1].sides[2][1] = 1
	
	map[3][2].sides[2][1] = 1
	map[3][2].sides[3][1] = 1
	
	map[3][3].sides[3][1] = 1
	map[3][3].sides[0][1] = 1
	


func GenerateEnemy(var size: int, var difficulty: int):
	
	current_size = size;
	self.difficulty = difficulty;
	
	for i in range(size):
		result.append([])
	
	for i in range(result.size()):
		for j in range(result.size()):
			result[i].append(Possibility.new(map, j, i))
		
	#setting the borders
	for i in range(size):
		result[0][i].possibilities.clear()
		result[0][i].possibilities.append(map[0][0])
		result[size-1][i].possibilities.clear()
		result[size-1][i].possibilities.append(map[0][0])
		result[i][0].possibilities.clear()
		result[i][0].possibilities.append(map[0][0])
		result[i][size-1].possibilities.clear()
		result[i][size-1].possibilities.append(map[0][0])
	for i in range(size):
		Collapse(i, 0);
		Collapse(i, size-1);
		Collapse(0, i);
		Collapse(size-1, i);
    
    #result[size/2][size/2].possibilities.clear();
    #result[size/2][size/2].possibilities.add(map[1][1]);
    
    #Collapse(size/2, size/2);
    
	result[size/2][size/2].possibilities.clear()
	result[size/2][size/2].possibilities.append(map[1][1])
	result[size/2][size/2].onBorder = true
    
    
    #Collapse(size/2, size/2);
    
    
    #result[4][6].possibilities.clear();
    #result[4][6].possibilities.add(map[1][2]);
    
    #Collapse(6, 4);
    
    ##println(result[3][4].possibilities.get(1).type);
	return result;
	

func Collapse(var x: int, var y: int):
	#print("Collapse at : " + str(x) + ", " + str(y))
	
	
	#println("Collapse at x:" + x + "; y:" + y);
	
	
	
	if ( y-1 >= 0 && !result[y-1][x].updateWith(result[y][x], 2)):
		Collapse(x, y-1)
	
	
	if ( x+1 < result.size() && !result[y][x+1].updateWith(result[y][x],3)):
		Collapse(x+1, y)
	
	
	
	if ( y+1 < result[0].size() && !result[y+1][x].updateWith(result[y][x],0)):
		Collapse(x, y+1)
	
	
	
	if ( x-1 >= 0 && !result[y][x-1].updateWith(result[y][x],1)):
		Collapse(x-1, y)
    
#check in the map of possibilities the next square to pick, then collapses its neighbours and goes into recursion
#if there is no more options then it stops and replaces remaining possibilities with the empty square;
func GenerateNextStep():
	
	var did_generate = false
	possiOnBorder.clear()
		
	for pY in result :
		for p in pY :
			
			if (p.onBorder) :
				possiOnBorder.append(p)
				#print("x:" + str(p.posX) + " ; y:" + str(p.posY))
	
	
	if (possiOnBorder.size() > 0):
		
		var square
		
		var nrand = rand_range(0, difficulty) + count
		
		var try_extension
		if nrand < difficulty-count*3:
			
			var posss = []
			for possi in possiOnBorder:
				for i in range(possi.possibilities.size()):
					if possi.possibilities[i].type == 5:
						posss.append(possi)
			
			if posss.size() >0:
				var chosen_pos = posss[rand_range(0, posss.size())]
				
				chosen_pos.generated = true
				chosen_pos.possibilities.clear()
				chosen_pos.possibilities.append(map[1][1])
				Collapse(chosen_pos.posX, chosen_pos.posY)
				return true
			else:
				
				did_generate = ChoseRandom()
				
		elif nrand < difficulty-count:
			
			var posss = []
			for possi in possiOnBorder:
				for i in range(possi.possibilities.size()):
					square = possi.possibilities[i]
					if square.type == 8 || square.type == 9 || square.type == 12 || square.type == 13 || square.type == 14 || square.type == 15:
						posss.append(possi)
			
			if posss.size() >0:
				var chosen_pos = posss[rand_range(0, posss.size())]
				
				var squares = []
				for s in chosen_pos.possibilities:
					if (s.type == 8 || s.type == 9 || s.type == 12 || s.type == 13 || s.type == 14 || s.type == 15):
						 squares.append(s)
				
				var chosenSquare = squares[rand_range(0, squares.size())]
				
				chosen_pos.generated = true
				chosen_pos.possibilities.clear()
				chosen_pos.possibilities.append(chosenSquare)
				Collapse(chosen_pos.posX, chosen_pos.posY)
				did_generate = true
			else:
				
				did_generate = ChoseRandom()
		else:
			
			
			var posss = []
			for possi in possiOnBorder:
				for i in range(possi.possibilities.size()):
					square = possi.possibilities[i]
					if square.type == 1 || square.type == 2 || square.type == 4 || square.type == 6:
						posss.append(possi)
						i = possi.possibilities.size()
			
			if posss.size() >0:
				var chosen_pos = posss[rand_range(0, posss.size())]
				
				var squares = []
				for s in chosen_pos.possibilities:
					if (s.type == 1 || s.type == 2 || s.type == 4 || s.type == 6):
						 squares.append(s)
				
				var chosenSquare = squares[rand_range(0, squares.size())]
				
				chosen_pos.generated = true
				chosen_pos.possibilities.clear()
				chosen_pos.possibilities.append(chosenSquare)
				Collapse(chosen_pos.posX, chosen_pos.posY)
				did_generate = true
			else:
				
				did_generate = ChoseRandom()
	count+=1
	
	return did_generate
	
	
	"""
	#println((int)random(6));
	print(possiOnBorder.size())
	
	if (possiOnBorder.size() > 0):
		var chosenPoss = possiOnBorder[rand_range(0, possiOnBorder.size())]
		
		if (chosenPoss.possibilities.size() > 0):
			var chosenSquare = chosenPoss.possibilities[rand_range(0, chosenPoss.possibilities.size())]
		
			chosenPoss.possibilities.clear()
			chosenPoss.possibilities.append(chosenSquare)
		
			#print("pos chosen : " + str(chosenPoss.posX) + " : " + str(chosenPoss.posY))
		
			#print("type : " + str(chosenSquare.type))
			#print(" ")
		
			Collapse(chosenPoss.posX, chosenPoss.posY)
		
			chosenPoss.onBorder = false;
		
		
		#GenerateNextStep();
	"""

func ChoseRandom():
	
	var chosenPoss = possiOnBorder[rand_range(0, possiOnBorder.size())]
		
	if (chosenPoss.possibilities.size() > 0):
		var chosenSquare = chosenPoss.possibilities[rand_range(0, chosenPoss.possibilities.size())]
		
		chosenPoss.generated = true
		chosenPoss.possibilities.clear()
		chosenPoss.possibilities.append(chosenSquare)
		
		#print("pos chosen : " + str(chosenPoss.posX) + " : " + str(chosenPoss.posY))
		
		#print("type : " + str(chosenSquare.type))
		#print(" ")
		
		Collapse(chosenPoss.posX, chosenPoss.posY)
		
		chosenPoss.onBorder = false;
		return true
	return false

func FullyGenerate():
	if (GenerateNextStep()):
		FullyGenerate();
	else:
		for row in result:
			for possibility in row:
				if (!possibility.generated || (possibility.possibilities[0].type == 0)):
					possibility.possibilities.clear()
