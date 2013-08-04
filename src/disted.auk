@include "reader.awk"
@include "dist.awk"

function disted(    _Table,i,j) {
  readcsv("data/weather2.csv",0,_Table)
  for(i in data[0]) 
    for(j in data[0])
      print dist(i,j,_Table[0]) | "sort -n"
}
function _disted(  _Table,i,j,k) {
  readcsv("data/weather2.csv",0,_Table)
  for(i in data[0]) {
      j= closest(i,_Table[0])
      k= furthest(i,_Table[0])
      print ""
      print i,rowprint(i,_Table[0])
      print j,rowprint(j,_Table[0]), "<<= close"
      print k,rowprint(k,_Table[0]), "<<= far"
    }}
