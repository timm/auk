@include "reader.awk"
@include "dist.awk"

function _disted(    _Table,a) {
  args("-d,data/weather2.csv,-w,?",a)
  readcsv(a["-d"],0,_Table)
  if (a["-w"] == "?")
    distedAll(_Table[0])
  else if (a["-w"] == "cf1")
    distedCloseFar(_Table[0],1)
 else if (a["-w"] == "cf0")
    distedCloseFar(_Table[0],0)
}
function distedAll(_Table,    i,j) {
  for(i in data) 
    for(j in data)
      print dist(data[i],data[j],_Table) | "sort -n"
}
function distedCloseFar(_Table,control,     i,j,k) {
  for(i in data) {
      j= closest(i,_Table,control)
      k= furthest(i,_Table)
      print ""
      print i,rowprint(data[i])
      print j,rowprint(data[j]), "<<= close"
      print k,rowprint(data[k]), "<<= far"     
  }}
