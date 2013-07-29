@include "project.awk"

function _projected(   _Table) {
  readcsv("data/weather2.csv",0, _Table)
  poles(0,_Table)
}
