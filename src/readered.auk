@include "reader.awk"

function _readered(   _Table) {
  readcsv("data/weather1.csv",0,_Table)
  o(mode,"m")
  o(mu,"mu")
  o(sd,"sd")
  o(dep[0],"dep")
  o(indep[0],"indep")
  o(order[0],"order")
  o(name[0],"name")
  tableprint(_Table[0])
}

function nasa93dem(    _Table) {
  readcsv("data/nasa93dem.csv",0,_Table)
}
