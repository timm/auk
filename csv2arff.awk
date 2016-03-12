@include "config"
@include "defs"

BEGIN { readcsv(",")  }

#_ 2arff 
function readcsv(sep,  _Table,
                 cols,str,r,numc) {
  t = table0(_Table)
  while ((getline str) > 0) {
    cols = split(str,a,sep)
    r++
    if(r == 1)
      header(t,a,cols,numc,_Nums)
    else
      row(t,a,cols,_Table) }}

function header(t,a,cols,numc, _Table,c,z) {
  for(c=1;c<=cols;c++) {
    z = a[c]
    txt
    if (z ~ NumC) {
      num0(c,  _Num)
    } else {
      sym0(c , _Sym)
      some0(c, _Some) }
   
}

function row(a,r,cols, _Table,c,z) {
  for(c=1;c<=cols;c++) {
    z = a[c]
    if (z ~ NumC)
      num1(z,  _Num)
    else {
      sym1(z , _Sym)
      some1(z, _Some) }}
