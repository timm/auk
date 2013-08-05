@include "project.awk"

function tiles(_Table) {
  print 11
  project(_Table,"tiles1")
}
function tiles1(at,_Table,   xs,ys,tiny,big,m,c,pre) {
  print "\n"
  m    = length(at)
  tiny = 2
  big  = sqrt(m)
  c    = 0
  pre  = ""
  asort(at,xs,"xsort")
  asort(at,ys,"ysort")
  tiles2(1,m,1,m,xs,ys,tiny,big,pre,m,c)
}
function tiles2(x0,x2,y0,y2, xs,ys, tiny,big,pre,m,c,  x,y) {
  print pre x0,x2,y0,y2, "#" m
  x= x0 + int((x2 - x0)/2)
  y= y0 + int((y2 - y0)/2)
  c= tiles3(x0  ,x  ,y0  ,y,  xs,ys, tiny,big,pre,c)
  c= tiles3(x0  ,x  ,y+1 ,y2, xs,ys, tiny,big,pre,c)
  c= tiles3(x+1 ,x2 ,y0  ,y,  xs,ys, tiny,big,pre,c)
  c= tiles3(x+1 ,x2 ,y+1 ,y2, xs,ys, tiny,big,pre,c)
  return c
}
function tiles3(x0,x2,y0,y2, xs,ys,tiny,big,pre,c,    x,y,tmp,m,i) {
  for(x=x0; x<=x2; x++) 
    for(y=y0; y<=y2; y++) 
      if (xs[x]["d"] == ys[y]["d"])
	tmp[++m] = xs[x]["d"]
  if (m >= big)
    c= tiles2(x0,x2,y0,y2,xs,ys,tiny,big,pre "|.. ",m,c)
  else 
    if (m > tiny)  {
      c++
      for(i in tmp) 
	print "\t" c,tmp[i] 
  }
  return c  
}
 
function _tiles(   _Table) {
  readcsv("data/nasa93dem.csv",0,_Table)
  tiles(_Table[0])
}
