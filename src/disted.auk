@include "reader.awk"
@include "dist.awk"

function _disted(    _Table) {
  readcsv("data/weather1.csv",0,_Table)
  for(i in data[0]) {
    o(data[0][i],i)
    j= closest(i,0,indep,_Table)
    k= furthest(i,0,indep,_Table)
    o(data[0][j],j " <<= close")
    o(data[0][j],k " <<= far")
