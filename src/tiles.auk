@include "project.awk"
@include "table.awk"

# give tiles a working memory
# pass round a table and create stuff

function tiles(_Tables,t,    _Tile,m,cl,xy) {
  xy = project(_Tables,t)
  tiny = 4
  pre  = ""
  m    = length(datas[xy])
  big  = 2*sqrt(m)
  cl    = 1
  watch= 1
  centers="centroids"
  makeTable(names[xy],centers,_Tables)
  tiles0(_Tables[xy],_Tile)
  tiles4(1,m,1,m,_Tables[xy],_Tile,_Tables,cl)
  return centers
}
function tiles0(_Table0,_Tile,  x,y,z,d,at) {
  x = colnum0["$_XX"]
  y = colnum0["$_YY"]
  z = colnum0["_ZZ"]  
  for(d in data0) {
    at[d]["d"] = d
    at[d]["x"] = data0[d][x]
    at[d]["y"] = data0[d][y]
  }
  asort(at,xs,"xsort")
  asort(at,ys,"ysort")
}
function tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,cl, 
		x,y) {
  x= x0 + int((x2 - x0)/2)
  y= y0 + int((y2 - y0)/2)
  cl= tile1(x0  ,x  ,y0  ,y,  _Table0,_Tile,_Tables,cl)
  cl= tile1(x0  ,x  ,y+1 ,y2, _Table0,_Tile,_Tables,cl)
  cl= tile1(x+1 ,x2 ,y0  ,y,  _Table0,_Tile,_Tables,cl)
  cl= tile1(x+1 ,x2 ,y+1 ,y2, _Table0,_Tile,_Tables,cl)
  return cl
}
function tile1(x0,x2,y0,y2, _Table0,_Tile,_Tables,cl,    
		x,y,has) {
  for(x=x0; x<=x2; x++) 
    for(y=y0; y<=y2; y++) 
      if (xs[x]["d"] == ys[y]["d"])
	has[x] = xs[x]["d"]
  if (watch)
    print sprintf("%3s:  ",cl) pre x0,x2,y0,y2, "#" length(has)
  if (length(has) >= big) {
    pre = pre "|.."
    return tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,cl)
  } 
  if (length(has) > tiny)  
    makeNewTable(has, ++cl,_Table0,_Tile,_Tables)
  return cl
}
function makeNewTable(has,cl,_Table0,_Tile,_Tables, 
		 z,one,d,row1,row2) {
  cl = cl*100
  makeTable(name0,cl,_Tables)
  z = colnum0["_ZZ"]  
  for(one in has) {
    d = has[one]
    copy(data0[d],row1)
    row1[z] = cl
    addRow(row1,_Tables[cl])
  }
  centroid(_Tables[cl],row2)
  row2[z] = cl
  addRow(row2,_Tables[centers])
}
function _tiles(   _Tables, t,centers,name) {
  resetSeed()
  t=0
  readcsv("data/nasa93dem.csv",t,_Tables)
  centers= tiles(_Tables,t)
  tableprint(_Tables[centers],"%5.3f")
  for(name in names) 
    if(name != t)
      tableprint(_Tables[name],"%5.3f")
}
function _tiles1(   _Table) {
  readcsv("data/autompg.csv",0,_Table)
  tiles(_Table[0])
}
