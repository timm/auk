@include "reader.awk"
@include "dist.awk"
@include "xval.awk"

function _knn(    _Table,a) {
  args("-d,data/weather1.csv,-s,1,-x,5,-b,5,-m,2,-k,1,-p,4.1",a)
  resetSeed(a["-s"])
  readcsv(a["-d"],0,_Table)
  xvals(_Table[0],a["-x"],a["-b"],"nb",a)
}
