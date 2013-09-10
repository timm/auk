@include "project.awk"
@include "table.awk"

# give tiles a working memory
# pass round a table and create stuff

function tiles(_Table) { project(_Table,"tiles0") }

function tiles0(at,_Table0,_Tables,    _Tile,m,c,t) {
  tiny = 4
  pre  = ""
  final= "final"
  m    = length(at)
  big  = 2*sqrt(m)
  c    = 1
  watch= 0
  tilesHeader(name0,header)
  asort(at,xs,"xsort")
  asort(xs,ys,"ysort")
  tiles4(1,m,1,m,_Table0,_Tile,_Tables,c)
  tableprint(_Table0,1)
  for(t in names) { print ""; tableprint(_Tables[t],1) }
}
function tilesHeader(name,header,    tmp,a,i) {
  split("$_x,$_y,!_cluster",tmp,",")
  appendn(name,tmp,header)
}
function tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,c, 
		   x,y) {
  x= x0 + int((x2 - x0)/2)
  y= y0 + int((y2 - y0)/2)
  c= tile1(x0  ,x  ,y0  ,y,  _Table0,_Tile,_Tables,c)
  c= tile1(x0  ,x  ,y+1 ,y2, _Table0,_Tile,_Tables,c)
  c= tile1(x+1 ,x2 ,y0  ,y,  _Table0,_Tile,_Tables,c)
  c= tile1(x+1 ,x2 ,y+1 ,y2, _Table0,_Tile,_Tables,c)
  return c
}
function tile1(x0,x2,y0,y2, _Table0,_Tile,_Tables,c,    
		x,y,here) {
  for(x=x0; x<=x2; x++) 
    for(y=y0; y<=y2; y++) 
      if (xs[x]["d"] == ys[y]["d"])
	here[x] = xs[x]["d"]
  if (watch)
    print pre x0,x2,y0,y2, "#" length(here)
  if (length(here) >= big) {
    pre = pre "|.."
    return tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,c)
  } 
  if (length(here) > tiny)  
    makeNewTable(here, ++c,_Table0,_Tile,_Tables)
  return c
}
function makeNewTable(here,c,_Table0,_Tile,_Tables, 
		 d,suffix,all,r,x) {
  makeTable(header,c,_Tables)
  for(x in here) {
    d         = here[x]
    suffix[1] = xs[x]["x"]
    suffix[2] = xs[x]["y"]
    suffix[3] = c
    appendn(data0[d],suffix,all)
    addRow(all,++r,_Tables[c]) }
}
function _tiles(   _Table) {
  readcsv("data/nasa93dem.csv",0,_Table)
  tiles(_Table[0])
}
function _tiles1(   _Table) {
  readcsv("data/autompg.csv",0,_Table)
  tiles(_Table[0])
}
