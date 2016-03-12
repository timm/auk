function dist(this,that,_Table) {
  return dist0(this,that,indep,_Table)
}
function dist0(this,that,what,_Table, unnorm, tracep, \
	      sum,k,v1,v2,aLittle,mid) {
  for(k in what)  {
    v1 = this[k]
    v2 = that[k]
    if(tracep) print ">","v1",v1,"v2",v2
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else if (k in nump) { 
      aLittle = 0.0000001
      mid     = (hi[k] - lo[k])/2
      if (v1 == "?") { 
	if (unnorm)
	  v1= v2 < mid ? hi[k] : lo[k]
	else
	  v1= v2 < mid ? 1 : 0
      }
      else
	if (!unnorm) 
	  v1= (v1- lo[k]) / (hi[k]- lo[k]+ aLittle)
      if (v2 == "?") {
	if (unnorm)
	  v2= v1 < mid ? hi[k] : lo[k]
	else
	  v2= v1 < mid ? 1 : 0
      }
      else {
	if (!unnorm)
	  v2= (v2- lo[k]) / (hi[k]- lo[k]+ aLittle) }
      sum += (v2 - v1)^2 
    } else {  
      if      (v1 == "?") sum += 1
      else if (v2 == "?") sum += 1
      else if (v1 != v2 ) sum += 1
      else sum += 0
  }}
  if(tracep) print ">","sum",sum,"n",length(what)
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
function neighbors(_Table,pairs) {
  return neighbors0(_Table,pairs,indep)
}
function neighbors0(_Table,pairs,what,unnorm,     from) {
  for(from in data) 
    neighbor(_Table,pairs,what,from,unnorm)
}
function neighbor(_Table,out,what,from, unnorm, 
		  to,tmp,m,max,z,here,d,j) {
  for(to in data) 
    if (to != from) {
      m++
      tmp[m]["to"] = to
      tmp[m]["x"] = d = dist0(data[from],data[to],what,_Table,unnorm)
    }
  max = asort(tmp,tmp,"xsort")
  for(m=1;m<=max;m++) {
     out[from][m]["to"] =  tmp[m]["to"] 
     out[from][m]["d"]  =  tmp[m]["x"] 
}}
