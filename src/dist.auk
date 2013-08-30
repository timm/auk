function dist(this,that,_Table) {
  return dist0(this,that,indep,_Table)
}
function dist0(this,that,what,_Table, \
	      sum,k,v1,v2,aLittle) {
  for(k in what)  {
    v1 = this[k]
    v2 = that[k]
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else if (k in nump) { 
      aLittle = 0.0000001
      if (v1 == "?") 
	v1= v2 < 0.5 ? 1 : 0
      else
	v1= (v1- lo[k]) / (hi[k]- lo[k]+ aLittle)
      if (v2 == "?") 
	v2= v1 < 0.5 ? 1 : 0
      else
	v2= (v2- lo[k]) / (hi[k]- lo[k]+ aLittle)
      sum += (v2 - v1)^2 
    } else {  
      if      (v1 == "?") sum += 1
      else if (v2 == "?") sum += 1
      else if (v1 != v2 ) sum += 1
      else sum += 0
  }}
  return sum^0.5 / length(what)^0.5
}
function closest(i,_Table,self,   d,min,out,j) {
  min = INF
  for(j in data) {
    if (i == j && ! self) continue
    if (( d = dist(data[i],data[j],_Table)) < min) { 
      min= d; out= j }
  }
  return out
}
function furthest(i,_Table,   d,max,out,j) {
  max = NINF
  for(j in data)   
    if ((d = dist(data[i],data[j],_Table)) > max) { 
      max = d; out = j }
  return out
}
