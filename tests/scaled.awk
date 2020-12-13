# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "scale"

### main
function main(f,    c,i,j,n,s,order) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  n=TabDom(i,order)
  Some(s)
  for(j=1;j<=n;j++)
    add(s, order[j].dom)
  SomeDiv(s)
  print(last(s.bins), order[n].dom)
  for(c in i.cols)  {
    if (i.cols[c].is=="Some") {
      SomeDiv(i.cols[c]) }} }

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

