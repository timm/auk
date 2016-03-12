@include "project.awk"

function _projected() {
  resetSeed()
  projected1("data/autompg.csv")
}
function projected1(f,  _Table,w) {
  readcsv(f,0, _Table)
  w = project(_Table,0)
  tableprint(_Table[w])
}
function proj1c(   _Table) {
  readcsv("data/autompg.csv",0, _Table)
  project(_Table[0])
}
function proj2d(   _Table) {
  readcsv("data/nasa93dem.csv",0, _Table)
  project(_Table[0])
}

function proj2e(   _Table) {
  readcsv("data/iris.csv",0, _Table)
  project(_Table[0])
}

function proj2f(   _Table) {
  readcsv("data/housing.csv",0, _Table)
  project(_Table[0])
}

function proj2g(   _Table) {
  readcsv("data/poi-3.0.csv",0, _Table)
  project(_Table[0])
}
