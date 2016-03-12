@include "lib.awk"
@include "reader.awk"
@include "labels.awk"

function _discrete(       _Table,bins,
                  breaks,labels,t1,b) {
  readcsv("data/weather3.csv",0,_Table)
  bins = 3
  t1 = discrete(_Table,0,bins,b)
  print t1
  o(b[bins],"breaks")
  tableprint(_Table[0])
  tableprint(_Table[t1])
}

function discrete(_Table,t,bins,b,   
		  breaks, labels,newNames,t1) {
  breaks="ewdbreaks" ; labels="ewdlabel"
  #breaks="gbreaks" ; labels="glabel"
  @breaks(b)  
  discreteNames(name[t],num[t],newNames)
  t1="D_" t
  makeTable(newNames, t1, _Table)
  discrete1(_Table[t],_Table[t1],bins,b[bins],labels) 
  return t1
}
function discrete1(_Table,_Table1,bins,b,labels,
		  a,d,k,val,max) {
   max = length(data)
  for(d=1;d<=max;d++)  {
    for(k in name) { 
      val = data[d][k]
      if (val != "?")
	if(k in num)  
	  val = @labels(k,val,bins,b,_Table) 
      a[k] = val 
    }
    addRow(a,_Table1)
}}
