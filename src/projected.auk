@include "project.awk"

function _projected(   _Table) {
  readcsv("data/weather2.csv",0, _Table)
  project(_Table[0])
}
function proj1d(   _Table) {
  readcsv("data/autompg.csv",0, _Table)
  project(_Table[0])
}

# set datafile separator ","
