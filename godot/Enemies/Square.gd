extends Node
class_name Square




var size := 3
var type: int
var sides: Array
  
  
func _init(t: int, a: int):
	type = t
	sides[0] = initTab(a)
	sides[1] = initTab(a)
	sides[2] = initTab(a)
	sides[3] = initTab(a)
    

  
  
func initTab(a: int) -> Array :
	
	var t: Array
	
	for i in range(t.size()) :
		t[i] = a;
	
	return t;
  
  
  
func isCompatible(other: Square , dir: int) -> bool:
	
	var result := true
	
	for i in range(size) :
		result &= (sides[((dir + 2)%4)][i] == other.sides[dir][i]) || sides[((dir + 2)%4)][i] == -1 || other.sides[dir][i] == -1
	
	return result;
  
  
