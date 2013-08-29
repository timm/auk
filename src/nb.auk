@include "reader.awk"
@include "uxval.awk"

function _knn(    _Table,a,seen) {
  o(ARGV,"argv")
  args("-d,data/weather1.csv,-s,1,-x,2,-b,2,-k,1,-p,4.1",a)
  resetSeed(a["-s"])
  readcsv(a["-d"],0,_Table)
  uxvals(_Table[0],a["-x"],a["-b"],"knn",a)
}
function knn(test,data,_Tables,a,  
	    h,total,where,t,want,got,acc,l) {
  where = klassAt(_Tables)
  for(t in test) {
    want  = data[t][where]
    got   = closestlikelihood(data[t],total,hypotheses,l,_Tables,
		      a["-k"],a["-m"])
    acc  += want == got
  }
  printf("%" a["-p"] "f\n",
    	100 * acc/length(test)) | "sort -n | fmt"
}
function likelihood(row,total,hypotheses,l,_Tables,k,m,
		    like,h,nh,prior,tmp,c,x,y,best) {
   like  = NINF ;    # smaller than any log
   total = total + k * length(hypotheses)
   for(h in hypotheses) {   
      nh    = length(datas[h])
      prior = (nh+k)/total
      tmp   = log(prior)
      for(c in terms[h]) {
	x = row[c]
	if (x == "?") continue
	y = counts[h][c][x] 
	tmp += log((y + m*prior) / (nh + m))
      }
      for(c in nums[h]) {
	x = row[c]
	if (x == "?") continue
	y = norm(x, mus[h][c], sds[h][c])
	tmp += log(y)
      }
      l[h] = tmp
      if ( tmp >= like ) {like = tmp; best=h}
   }
   return best
}
