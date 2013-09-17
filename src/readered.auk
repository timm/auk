@include "reader.awk"

function _readered(     _Table,   seen,x,f){
  readcsv("data/weather4.csv", 0, _Table)
  #bayes(0,_Table)
  f="%4.2f"
  tableprint(_Table[0],f)
  #tableprint(_Table["yes"],f)
  #tableprint(_Table["no"], f)
}

function nasa93dem(    _Table) {
  readcsv("data/nasa93dem.csv",0,_Table)
}

