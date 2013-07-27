function dist(i,j,x,y,what,_Table, \
	      sum,k,v1,v2,e,inc) {
  for(k in what)  {
    inc = 0
    v1 = data[x][i][k]
    v2 = data[y][j][k]
    if (v1 == "?" && v2 == "?") 
      inc = 1
    else if (k in num) {
      e = 0.00001
      if (v1 != "?") 
	v1= (v1- lo[x][k]) / (hi[x][k]- lo[x][k]+ e)
      if (v2 != "?") 
	v2= (v2- lo[y][k]) / (hi[y][k]- lo[y][k]+ e)
      if (v1 == "?") 
	v1= v2 < 0.5 ? 1 : 0
      if (v2 == "?") 
	v2= v1 < 0.5 ? 1 : 0
      inc = (v2 - v1)^2 
    } else {  
      if      (v1 == "?") inc = 1
      else if (v2 == "?") inc = 1
      else if (v1 != v2 ) inc = 1
      else inc = 0
    }
    sum += inc
  }
  return sum^0.5 / length(what)^0.5
}
function closest(i,x,what,_Table,   d,min,out,j) {
  min = 1.1
  for(j in data[x])
    if (j != i) 
      if (( d = dist(i,j,x,x,what,_Table)) < min) { 
	min= d; out= j }
  return out
}
function furthest(i,x,what,_Table,   d,max,out,j) {
  max = 0
  for(j in data[x])
    if (j != i)
      if ((d = dist(i,j,x,x,what_Table)) > max) { 
	max = d; out = j }
  return out
}
