BEGIN { FS=OFS=","}  

@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

function project(_Table,then,  d,east,west) {
  resetSeed()
  then = then ? then : "projections"
  d    = anyi(data) 
  east = furthest(d,   _Table)
  west = furthest(east,_Table)
  project0(east,west,then,_Table)
}
function project0(east,west,then,_Table,   
	      a,b,c,d,x,m,at,some) {
  printf("+")
  some = 0.000001
  c = dist(east,west,_Table)
  for(d in data) {
    a = dist(d,east,_Table)
    b = dist(d,west,_Table)
    if (b > c) return project0(east,d,then,_Table)
    if (a > c) return project0(d,west,then,_Table)
    printf(".")
    m++
    at[m]["d"]= d
    at[m]["x"]= x= (a^2 + c^2 - b^2) / (2*c + some)
    at[m]["y"]=    (a^2 - x^2)^0.5   
  }
  @then(at,_Table)
}
function projections(at,_Table,    
		     xs,i,d,com,max) {
  asort(at,xs,"xsort")
  com = malign()
  max = length(xs)
  print ""
  print rowprint(name,order) ",$_x,$_y" | com
  for(i=1;i<=max;i++) {
    d = xs[i]["d"]
    print rowprint(data[d], order),
          xs[i]["x"],xs[i]["y"] | com
  }
  close(com)
}
