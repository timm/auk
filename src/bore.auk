@include "lib.awk"
@include "sdiscrete.awk"

function _bore(  _Table, f,t1,bins,tiny,
		 want,_Tables,t,out,enough,some,best,m,all) {
  #f="data/weather0.csv";  bins = 3; tiny=0.3; want="yes";enough=0.5
  f="data/diabetes.csv";  bins = 7; tiny=0.3; enough=0.5; want="tested_negative"
  readcsv(f,0,_Table)  
  t1 = sdiscrete(_Table, 0, bins, tiny)
  #tableprint(_Table[t1])
  tables(_Table[t1],_Tables)
  #for(t in names) 
  #  tableprint(_Tables[t])
  m=bore(_Tables,want,enough,all)
  o(all,"all")
  forwardSelect(-1,1,m,all,want,_Tables,best)
  o(best,"best")
}  
function bore(_Tables,want,enough,out,   
	      t,yes,no,best,rest,x,y,b,r,tmp,max,inc,m,items) {
 for(t in names)  {
   items = length(datas[t])
   t == want ? best += items : rest += items
   for(x in indeps[t]) 
     for(y in counts[t][x]) {
       inc = counts[t][x][y]
       t == want ? yes[x][y] += inc : no[x][y] += inc
     }}
 for(x in yes)
   for(y in yes[x]) {
     b = yes[x][y]/ best
     r = no[ x][y]/ rest
     if (b > r) {
       m++
       out[m]["x"] = x
       out[m]["y"] = y
       out[m]["z"] = tmp = b^2/(b+r)
       if (tmp > max) max=tmp
     }}
 for(m in out)
   if (out[m]["z"] < enough*max)
     delete out[m]
 return asort(out,out,"zsortdown")
}
function forwardSelect(b4,lo,hi,all,want,_Tables,out,
		       t,m,total,good,score,some,tmp,best,rest) {
  if (lo > hi) return somes(all,lo-1,out)
  somes(all,lo,some)
  for(t in names)  {
    tmp    = rowsWith(some,_Tables[t])
    m     += tmp
    total += tmp
    t == want ? best += tmp : rest += tmp 
  }
  score = best*best/(best+rest)
  if(score > b4)
    return forwardSelect(score,lo+1,hi,all,want,_Tables,out)
  else
    somes(all,lo-1,out)
}
function somes(all,max,some,   i,x,y) {
  for(i=1;i<=max;i++) {
    x =  all[i]["x"]
    y  = all[i]["y"]
    some[x][y]
}}
