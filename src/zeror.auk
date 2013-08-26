@include "reader.awk"
@include "xval.awk"

function _zeror(    _Table,a,seen) {
  o(ARGV,"argv")
  args("-d,data/weather1.csv,-s,1,-x,5,-b,5",a)
  resetSeed(a["-s"])
  readcsv(a["-d"],0,_Table)
  xvals(_Table[0],a["-x"],a["-b"],"zeror",a)
}
function zeror(test,data,hypotheses,_Tables,a,  
	    h,these,most,where,want,got,acc) {
  for(h in hypotheses) { 
     these = length(datas[h])
     if (these > most) {
       most = these
       got = h
  }}
  print "#got",got
  where = klassAt(_Tables)
  for(t in test) {
    want  = data[t][where]
    acc  += want == got
  }
  print 100 * acc/length(test) | "sort -n"
}
