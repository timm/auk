@include "reader.awk"

function _readered(   _Table) {
  readcsv("data/weather1.csv",0,_Table)
  o(mode,"m")
  o(mu,"mu")
  o(sd,"sd")
  o(dep[0],"dep")
  o(indep[0],"indep")
  tableprint(_Table[0])
}
