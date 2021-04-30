extends Node
class_name Possibility


var possibilities: Array
  
var posX: int
var posY:int

#flag to know if the possibility is on the border of the generation
var onBorder := false
var generated := false
  
func _init(all: Array, pX: int, pY: int) :
	
	posX = pX
	posY = pY
	
	
	for i in range(all.size()) :
		for j in range(all[0].size()) :
			possibilities.append(all[i][j])



func add(s : Square) -> void :
	possibilities.append(s)



func updateWith(other: Possibility, dir: int) :
	var okay := false
	"""
	print("Update square : " + str(posX) + ", " + str(posY))
	print("With square : " + str(other.posX) + ", " + str(other.posY))
	print("Containing : ")
	
	for s in possibilities :
		print(s.type + ", ")

	print("\n and")
	for s in other.possibilities :
		print(s.type + ", ")
	
	print("")
	
	"""
	var toRemove : Array
	
	for s in possibilities :
		okay = false
		for s2 in other.possibilities :
			if (!okay) :
				okay = okay || s2.isCompatible(s, dir)
		
		if (!okay) :
			toRemove.append(s)
	
	if (other.possibilities.size() == 1) :
		for s2 in other.possibilities :
			onBorder = onBorder || (s2.type==5)
			onBorder = onBorder || (s2.type==8 && (dir==0 ||dir==2))
			onBorder = onBorder || (s2.type==9 && (dir==1 ||dir==3))
			onBorder = onBorder || (s2.type==12 && (dir==2 ||dir==3))
			onBorder = onBorder || (s2.type==13 && (dir==3 ||dir==0))
			onBorder = onBorder || (s2.type==14 && (dir==0 ||dir==1))
			onBorder = onBorder || (s2.type==15 && (dir==1 ||dir==2))
	
	for r in  toRemove :
		possibilities.remove(possibilities.find(r))
	
	
	if (possibilities.size() == 1) :
		onBorder = false
		generated = true
	
	
	return toRemove.size() == 0;
    
  
  
