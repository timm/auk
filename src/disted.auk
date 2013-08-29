@include "reader.awk"
@include "dist.awk"

function _disted(    _Table,a) {
  args("-d,data/weather1.csv,-w,?",a)
  readcsv("data/weather1.csv",0,_Table)
  if (a["-w"] == "?")
    distedAll(_Table[0])
  else if (a["-w"] == "cf")
    distedCloseFar(_Table[0])
}
function distedAll(_Table,    i,j) {
  for(i in data) 
    for(j in data) 
      print dist(i,j,_Table) | "sort -n"
}
function distedCloseFar(  _Table,i,j,k) {
  for(i in data) {
      j= closest(i,_Table,1)
      k= furthest(i,_Table)
      print ""
      print i,rowprint(data[i])
      print j,rowprint(data[j]), "<<= close"
      print k,rowprint(data[k]), "<<= far"     
  }}
