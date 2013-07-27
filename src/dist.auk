function dist(i,j,x,y,what,_Table,\
              sum,n,k,v1,v2,e) {
  e = 0.00001
  for(k in what)  {
    v1 = data[x][i][k]
    v2 = data[y][j][k]
    n += 1
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else if (k in num) {
      if (v1 != "?") 
	v1= (v1- lo[x][k]) / (hi[x][k]- lo[x][k]+ e)
      if (v2 != "?") 
	v2= (v2- lo[y][k]) / (hi[y][k]- lo[y][k]+ e)
      if (v1 == "?") v1= v2 < 0.5 ? 1 : 0
      if (v2 == "?") v2= v1 < 0.5 ? 1 : 0
      sum += ((v2 - v1)^2)  
    } else {  
      if      (v1 == "?") sum += 1
      else if (v2 == "?") sum += 1
      else if (v1 != v2 ) sum += 1 }
    }
  return sum^0.5 / n^0.5
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
