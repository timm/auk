@include "lib.awk"

function readcsv(f,z,_Table,   str,a,r) {
   FS=","; RS="\n"
   while(1) { 
     str = line(f)
     if (str == -1)  return 
     if (split(str,a,FS)) {
       r ? row(a,r,_Table[z]) : tables(a,z,_Table) 
       r++  }}
}
function tables(a,z,_Table,  c,x,isNum,j,max) {
  max = length(a)
  for(c=1;c<=max;c++) {
    if (a[c] ~ /\?/) continue
    order[z][++j] = c
    new3d(data,z,c)
    x = name[z][c] = a[c]
    isNum = 1
    if     (x~ /=/ ) {dep[z][c];   klass[z][c];isNum=0}
    else if(x~ /\+/) {dep[z][c];   more[z][c]         }
    else if(x~ /-/ ) {dep[z][c];   less[z][c]         }
    else if(x~ /\$/) {indep[z][c]; num[z][c]          }
    else             {indep[z][c]; term[z][c]; isNum=0}
    if (isNum) {
      nump[z][c]
      hi[z][c] = -1 * (lo[z][c] = 10**32)
      n[z][c]  = mu[z][c] = m2[z][c] = sd[z][c] = 0 
    } else { 
      wordp[z][c]
      new3d(count,z,c) 
      new3d(mode,z,c)
      most[z][c] = 0 }}
}
function row(a,r,_Table,   c,x,new,delta) {
  for(c in name) { 
    x = data[r][c] = a[c] 
    if (x !~ /?/) {
      if (c in wordp) { 
	new = ++count[c][x]
	if (new > most[c]) {
	  mode[c] = x
	  most[c] = new }
      } else {
	x = data[r][c] = x + 0 # coercion to a number
	if (x > hi[c]) hi[c] = x
	if (x < lo[c]) lo[c] = x 
	n[c]  += 1
	delta  = x - mu[c]
	mu[c] += delta/n[c]
	m2[c] += delta*(x - mu[c])
	if (n[c] > 1) 
	  sd[c] = (m2[c]/(n[c] - 1))^0.5 }}}
}
function rowsprint(_Table,   max,i) {
  max =length(data)
  for(i=1;i<=max;i++)
    print i, rowprint(i,_Table)
}
function rowprint(i,_Table,   max,j,c,str,sep) {
  sep=FS
  max = length(order)
  for(j=1;j<=max;j++) {
    c = order[j]
    str = str sep data[i][c]
    sep =","
  }
  return str
}
