@include "lib.awk"
@include "reader.awk"

function xvals(_Table,x,b,f,a,   rows,b1,s) {
  indexes(data,rows)
  s = int(length(rows)/b)
  while(x-- > 0) {
    shuffle(rows)
    b1 = b
    for(b1=0; b1<b; b1++)
      xval(b1*s+1, (b1+1)*s,rows,_Table,f,a)
  }
}
function xval(start,stop,rows,_Table,f,a,
	      rmax,r,d,x,test,hypotheses,_Tables) {
  rmax=length(rows)
  for(r=1;r<=rmax;r++) {
    d= rows[r]
    if (r>= start && r <= stop) 
      test[d]
    else {
      x = klass1(d,_Table)
      if (++hypotheses[x] == 1) 
	makeTable(name,x,_Tables)
      addRow(data[d],_Tables[x])
  }}
  print @f(test,data,hypotheses,_Tables,a)
}
function _xval(    _Table, a) {
  readcsv("data/weather1.csv",0,_Table)
  xvals(_Table[0],2,2,"xvalTest1",a)
}
function xvalTest1(test,data,hypotheses,_Tables,a,    h) {
  print "\n========================="
  for(h in hypotheses) {  
    tableprint(_Tables[h],"%5.2f")
}}
