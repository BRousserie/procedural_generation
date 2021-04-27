extends Node
class_name EnemyGenerator

  
var result: Array;
  
var masks := [
	[[1,1,1],[1,1,1],[1,1,1]],
	[[1,1,0],[0,1,1],[0,0,0]]
  ];

var map: Array #<Square>
  
var current_size := 0
  
func _init():
	#this.map = new Square[4][4];
	for i in range (4):
		map.append([])
	
	
	for i in range(map.size()):
		for j in range(map[0].size()):
			map[i].append(Square.new(i*4 + j, 0))
		
	
	
	map[0][1].sides[2][3] = 1
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
	
	for i in range(result.size()):
		for j in range(result.size()):
			result[i][j] = Possibility.new(map, j, i)
		
	
    
    #result[size/2][size/2].possibilities.clear();
    #result[size/2][size/2].possibilities.add(map[1][1]);
    
    #Collapse(size/2, size/2);
    
	result[size/2][size/2].possibilities.clear()
	result[size/2][size/2].possibilities.add(map[1][1])
	result[size/2][size/2].onBorder = true
    
    
    #Collapse(size/2, size/2);
    
    
    #result[4][6].possibilities.clear();
    #result[4][6].possibilities.add(map[1][2]);
    
    #Collapse(6, 4);
    
    ##println(result[3][4].possibilities.get(1).type);
	#return result;
	

func Collapse(var x: int, var y: int):
	print("Collapse at : " + str(x) + ", " + str(y))
	
	
	#println("Collapse at x:" + x + "; y:" + y);
	
	
	
	if ( y-1 >= 0 && !result[y-1][x].updateWith(result[y][x], 2)):
		Collapse(x, y-1)
	
	
	if ( x+1 < result.size() && !result[y][x+1].updateWith(result[y][x],3)):
		Collapse(x+1, y)
	
	
	
	if ( y+1 < result[0].size() && !result[y+1][x].updateWith(result[y][x],0)):
		Collapse(x, y+1);
	
	
	
	if ( x-1 >= 0 && !result[y][x-1].updateWith(result[y][x],3)):
		Collapse(x-1, y);
    
#check in the map of possibilities the next square to pick, then collapses its neighbours and goes into recursion
#if there is no more options then it stops and replaces remaining possibilities with the empty square;
func GenerateNextStep():
	
	var possiOnBorder : Array;
	
	for pY in result :
		for p in pY :
			
			if (p.onBorder) :
				possiOnBorder.append(p)
				print("x:" + str(p.posX) + " ; y:" + str(p.posY))
				
				
	#println((int)random(6));
	print(possiOnBorder.size())
	
	if (possiOnBorder.size() > 0):
		var chosenPoss = possiOnBorder[rand_range(0, possiOnBorder.size())]
		
		var chosenSquare = chosenPoss.possibilities[rand_range(0, chosenPoss.possibilities.size())]
		
		chosenPoss.possibilities.clear()
		chosenPoss.possibilities.add(chosenSquare)
		
		print("pos chosen : " + str(chosenPoss.posX) + " : " + str(chosenPoss.posY))
		
		print("type : " + str(chosenSquare.type))
		print(" ")
		
		Collapse(chosenPoss.posX, chosenPoss.posY)
		
		chosenPoss.onBorder = false;
		
		
		#GenerateNextStep();
