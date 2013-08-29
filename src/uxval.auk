@include "lib.awk"
@include "reader.awk"

function uxvals(_Table,x,b,f,a,   rows,b1,s) {
  indexes(data,rows)
  s = int(length(rows)/b)
  while(x-- > 0) {
    shuffle(rows)
    b1 = b
    for(b1=0; b1<b; b1++)
      uxval(b1*s+1, (b1+1)*s,rows,_Table,f,a)
  }
}
function uxval(start,stop,rows,_Table,f,a,
	      rmax,r,d,test,_Tables) {
  makeTable(name,"train",_Tables)
  rmax=length(rows)
  for(r=1;r<=rmax;r++) {
    d= rows[r]
    if (r>= start && r <= stop) 
      test[d]
    else 
      addRow(data[d],_Tables["train"])
  }
  @f(test,data,_Tables["train"],a)
}
function _uxval(    _Table, a) {
  args("-d,data/weather1.csv,-x,2,-b,2,-s,1",a)
  resetSeed(a["-s"])
  readcsv(a["-d"],0,_Table)
  uxvals(_Table[0],a["-x"],a["-b"],"uxvalTest1",a)
}
function uxvalTest1(test,data,_Table1,a,    h) {
  print "\n========================="
  tableprint(_Table1,"%5.2f")
}
