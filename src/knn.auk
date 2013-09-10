@include "reader.awk"
@include "dist.awk"
@include "uxval.awk"

function _knn(    _Tables,a) {
  args("-d,data/weather2.csv,-s,1,-x,5,-b,5,-m,2,-k,5,-p,4.1,--once,0",a)
  resetSeed(a["-s"])
  readcsv(a["-d"],0,_Tables)
  uxvals(_Tables[0],a["-x"],a["-b"],"knn",a)
}
function knn(test,data,_Table1,a,      where,d,got,want,acc) {
  if (a["--once"]) tableprint(_Table1)
  for(where in klass1) break
  printf(".")
  for(d in test)  {
    want = data[d][where]
    got = knn1(data[d],_Table1,a,where)
    acc += want == got
    if (a["--once"]) {
      print want,got
      exit
    }
  }
  printf("%" a["-p"] "f\n",
	 100 * acc/length(test)) | "sort -n | fmt"
}
function knn1(this,_Table,a,where,     sorted,seen,kmax,k) {
  kmax = neighbors(this,  _Table,sorted)
  if (a["--once"]) {
    print rowprint(this)
    for(k=1;k<=kmax;k++)
      print k,sorted[k]["x"],rowprint(data[sorted[k]["d"]])
  }
  nearestk(a["-k"],_Table,where,sorted, seen)
  return mostSeen(seen)
}
function neighbors(this,_Table,sorted,    d,lst) {
  for(d in data) {
    lst[d]["x"] = dist(this, data[d], _Table)    
    lst[d]["d"] = d
  }
  return asort(lst,sorted,"xsort")
}
function nearestk(k,_Table,where,sorted,seen,    i, that, got) {
  for(i=1;i<=k;i++) {
    that      = sorted[i]["d"]
    got       = data[that][where]
    seen[got]++
  }
}
function mostSeen(seen,    x,max,out) {
  for(x in seen) 
    if (seen[x] > max ) {
      max = seen[x]
      out = x
    }
  return out
}
