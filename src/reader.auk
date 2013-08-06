@include "lib.awk"
@include "table.awk"

function readcsv(f,z,_Table,   str,a,r) {
  FS=","; RS="\n"
  while(1) { 
    str = line(f)
    if (str == -1)  {
      if (!r) print "WARNING: empty or missing file " f
      return 
    }
    if (split(str,a,FS)) {
      if (r)
	addRow(a,r,_Table[z]) 
      else 
	makeTable(a,z, _Table) 
    r++  }}
}
function makeTable(a,z,_Table,  c,x,isNum,from,max) {
  max = length(a)
  new2d(wordp,z)
  for(from=1;from<=max;from++) {
   if (a[from] ~ /\?/) continue
    c++
    order[z][c] = from
    new3d(data,z,c)
    x = name[z][c] = a[from]
    isNum = 1
    if     (x~ /=/ ) {dep[z][c];   klass[z][c];isNum=0}
    else if(x~ /+/)  {dep[z][c];   more[z][c]         }
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
function addRow(a,r,_Table,   c,x,new,delta,from) {
  for(c in name) {
    from = order[c]
    x = data[r][c] = a[from] 
    if (x !~ /?/) {
      n[c]  += 1
      if (c in wordp) { 
	new = ++count[c][x]
	if (new > most[c]) {
	  mode[c] = x
	  most[c] = new }
      } else {
	x = data[r][c] = x + 0 # coercion to a number
	if (x > hi[c]) hi[c] = x
	if (x < lo[c]) lo[c] = x 
	delta  = x - mu[c]
	mu[c] += delta/n[c]
	m2[c] += delta*(x - mu[c])
	if (n[c] > 1) 
	  sd[c] = (m2[c]/(n[c] - 1))^0.5 }}}
}


