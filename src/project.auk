BEGIN { FS=OFS=","}  

@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

function poles(_Table,  d,east,west) {
  d    = anyi(data) 
  east = furthest(d,_Table)
  west = furthest(east,_Table)
  pole(east,west, _Table)
}
function pole(east,west,_Table,    
	      a,b,c,d,x,xs,m,at,some,com) {
  printf("+")
  some = 0.000001
  c = dist(east,west,_Table)
  for(d in data) {
    a = dist(d,east,_Table)
    b = dist(d,west,_Table)
    print a,b,c
    if (b > c) return pole(east,d,_Table)
    if (a > c) return pole(d,west,_Table)
    printf(".")
    m++
    at[m]["d"]= d
    at[m]["x"]= x= (a^2 + c^2 - b^2) / (2*c + some)
    at[m]["y"]= (a^2 - x^2)^0.5   
  }
  asort(at,xs,"xsort")
  showXY(xs,_Table)
}
function showXY(xs,_Table,    i,d,com,max) {
  com = malign()
  max = length(xs)
  print ""
  print rowprint(name,order) ",$_x,$_y" | com
  for(i=1;i<=max;i++) {
    d = xs[i]["d"]
    print rowprint(data[d], order),
      xs[i]["x"],xs[i]["y"] | com
}}