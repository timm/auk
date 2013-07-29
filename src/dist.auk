function apart(i,j,z,_Table) {
  return dist(i,j,z,z,indep[z],_Table)
}
function dist(i,j,x,y,what,_Table, \
	      sum,k,v1,v2,e) {
  for(k in what)  {
    v1 = data[x][i][k]
    v2 = data[y][j][k]
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else if (k in nump[x]) { 
      e = 0.0000001
      if (v1 != "?") 
	v1= (v1- lo[x][k]) / (hi[x][k]- lo[x][k]+ e)
      if (v2 != "?") 
	v2= (v2- lo[y][k]) / (hi[y][k]- lo[y][k]+ e)
      if (v1 == "?") 
	v1= v2 < 0.5 ? 1 : 0
      if (v2 == "?") 
	v2= v1 < 0.5 ? 1 : 0
      sum += (v2 - v1)^2 
    } else {  
      if      (v1 == "?") sum += 1
      else if (v2 == "?") sum += 1
      else if (v1 != v2 ) sum += 1
      else sum += 0
  }}
  return sum^0.5 / length(what)^0.5
}
function closest(i,z,_Table,   d,min,out,j) {
  min = 1.1
  for(j in data[z]) 
    if (j != i) 
      if (( d = apart(i,j,z,_Table)) < min) { 
	min= d; out= j }
  return out
}
function furthest(i,z,_Table,   d,max,out,j) {
  max = 0
  for(j in data[z])
    if (j != i)
      if ((d = apart(i,j,z,_Table)) > max) { 
	max = d; out = j }
  return out
}
