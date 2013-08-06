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
      print i,rowprint(data[0][i])
      print j,rowprint(data[0][j]), "<<= close"
      print k,rowprint(data[0][k]), "<<= far"
     
    }}
