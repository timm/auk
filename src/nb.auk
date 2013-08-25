@include "reader.awk"
@include "xval.awk"

function _nb(    _Table,a,seen) {
  args("-o,data/weather1.csv,-s,1,-x,5,-b,5,-m,2,-k,1",a)
  resetSeed(a["-s"])
  readcsv(a["-o"],0,_Table)
  xvals(_Table[0],a["-x"],a["-b"],"nb",a)
}
function nb(test,data,hypotheses,_Table0,a,  
	    h,total,where,t,want,got,acc,l) {
  for(h in hypotheses) 
     total += length(data0[h])
  where = klassAt(_Table0)
  for(t in test) {
    want  = data0[t][where]
    print "[",want,"]"
    got   = likelihood(data0[t],total,hypotheses,l,_Table0,
		      a["-k"],a["-m"])
    acc  += want == got
  }
  print 100 * acc/length(test)
}
function likelihood(cells,total,hypotheses,l,_Table,k,m,
		    like,h,nh,prior,tmp,c,x,y,best) {
   like  = NINF ;    # smaller than any log
   total = total + k * length(hypotheses)
   for(h in hypotheses) {
      nh    = length(data[h])
      prior = (nh+k)/total
      tmp   = log(prior)
      for(c in term) {
	x = cells[c]
	if (x ~ /\?/) continue
	y = (x in count[h][c]) ? count[h][c][x] : 0 
	tmp += log((y + m*prior) / (nh + m))
      }
      for(c in num) {
	x = cells[c]
	if (x ~ /\?/) continue
	y = norm(x, mu[h][c], sd[h][c])
	tmp += log(y)
      }
      l[h] = tmp
      if ( tmp >= like ) {like = tmp; best=h}
   }
   return best
}
