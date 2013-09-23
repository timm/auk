BEGIN { FS=OFS=","}  

@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

function project(_Table,t,  d,east,west,x,y) {
  d    = anyi(data) 
  east = furthest(d,   _Table[t])
  west = furthest(east,_Table[t])
  project0(east,west,_Table[t],x,y)
  return widen(_Table,t,x,y)
}
function project0(east,west,_Table,x,y,
	      a,b,c,d,some) {
  printf("+")
  some = 0.000001
  c = dist(data[east],data[west],_Table)
  for(d in data) {
    a = dist(data[d],data[east],_Table)
    b = dist(data[d],data[west],_Table)
    if (b > c) 
      return project0(east,d,_Table,x,y)
    if (a > c) 
      return project0(d,west,_Table,x,y)
    printf(".")
    x[d]=  (a^2 + c^2 - b^2) / (2*c + some)
    y[d]=  (a^2 - x[d]^2)^0.5   
  }
}
function widen(_Table,t,x,y,   w,d,wider,adds,c) {
  copy(name[t],adds)
  push("$_XX",adds)
  push("$_YY",adds)
  push("$_Hell",adds)
  push("_ZZ",adds)
  w = "_" t
  makeTable(adds,w,_Table)
  for(d in data[t]) {
    copy(data[t][d],wider)
    push(x[d],      wider)
    push(y[d],      wider)
    push(fromHell(data[t][d],_Table[t]),wider)
    push(0,         wider)
    addRow(wider,_Table[w])
  }
  return w
}
