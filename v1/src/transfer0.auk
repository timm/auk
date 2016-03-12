BEGIN { FS=OFS=","}  

@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

function pair(  i,l,r) {
  i = anyi(Data) 
  l = furthest(i)
  r = furthest(l)
  pair1(l,r)
}
function pair1(l,r,    a,b,c,m,n,at,xs,ys) {
  printf("+")
  c = dist(l,r)
  for(m in Data) {
    a = dist(m,l)
    b = dist(m,r)
    if (b > c) return pair1(l,b)
    if (a > c) return pair1(a,r)
    printf("=")
    n++
    at[n]["m"] = m
    at[n]["x"] = (a^2 + c^2 - b^2) / (2*c) ;
    at[n]["y"] = (a^2 - x^2)^0.5   
  }
  asort(at,xs,"xsort"); # o(xs,"xs")
  asort(at,ys,"ysort"); #o(ys,"ys")
  print ""
  tile(1,n,1,n,xs,ys,2,sqrt(n),"")
}
function xsort(r1,x1,r2,x2) { return x1["x"] - x2["x"] }
function ysort(r1,x1,r2,x2) { return x1["y"] - x2["y"] }

function tile(x0,x2,y0,y2, xs,ys, tiny,big,d) {
  x1 = int(x0 + (x2 - x0)/2)
  y1 = int(y0 + (y2 - y0)/2)
  tile1(x0   ,x1 ,y0   ,y1, xs,ys, tiny,big,d)
  tile1(x0   ,x1 ,y1+1 ,y2, xs,ys, tiny,big,d)
  tile1(x1+1 ,x2 ,y0   ,y1, xs,ys, tiny,big,d)
  tile1(x1+1 ,x2 ,y1+1 ,y2, xs,ys, tiny,big,d)
}

BEGIN { Ntiles=0 }
function tile1(x0,x2,y0,y2, xs,ys,tiny,big,d,    x1,y1,tmp,n) {
  print d x0,x2,y0,y2
  for(x1=x0; x1<=x2; x1++) {
    for(y1=y0; y1<=y2; y1++) {
      if (xs[x1]["m"] == ys[y1]["m"]) {
	n++
	tmp[n] = xs[x1]["m"]
      }}}
  if (n>0) {
    if (n >= big)
      tile(x0,x2,y0,y2,xs,ys,tiny,big,d "|.. ")
    else if (n > tiny)  {
      Ntiles++
      for(n in tmp)
	print Ntiles,tmp[n]
    }}}
END { 
  srand(Seed ? Seed : 1) 
  pair()
}
