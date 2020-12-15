# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "scale"

### main
function main(f,    c,i,j,n,s,order,len) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i,order)
  oo(i.rows)
  #print(len)
  #oo(i.rows)
  for(j=1;j<=len; j++) { oo(i.rows[j]) } # j } # i.rows[j].group }
}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

