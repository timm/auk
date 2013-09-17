@include "lib.awk"
@include "reader.awk"
@include "labels.awk"

function _discrete(_Table,b,bins,newNames,i,
                  breaks,labels) {
  readcsv("data/weather2.csv",0,_Table)
  #breaks="ewdbreaks" ; labels="ewdlabel"
  breaks="gbreaks" ; labels="glabel"
  @breaks(b)  
  bins = 3
  discreteNames(name[0],num[0],newNames)
  makeTable(newNames, 1, _Table)
  discrete(_Table[0],_Table[1],bins,b[bins],labels) 
  o(b[bins],"breaks")
  tableprint(_Table[0])
  tableprint(_Table[1])
}

function discrete(_Table,_Table1,bins,b,labels,
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
