function Some(i) {
  Obj(i); is(i,"Some")
  i.n=0
  i.max=30
  has(i,"all") }

function _Add(i,v, pos) {
  if (v == "?") return
  i.n++
  if (i.n <= i.max) {
    i.all[ length(i.all)+1 ] = v
    i.ready=0
  } else {
    if (i.n == i.max) 
      _Sorted(i)
    if (rand() < i.max/i.n) {
      if (v< i.all[1] || v>i.all[i.max]) {
        i.all[1+int(rand()* length(i.all))] = v
        i.ready=0
      } else 
        i.all[ binChop(i.all,v) ] = v}} 
  return v }

function _Ready(i) {
  if(!i.ready) {#print("-",i.n); 
      i.ready=asort(i.all) }}

function binChop(a,x,           y,lo, hi,mid)  {
  lo = 1
  hi = length(a)
  do {
    mid = int((hi + lo) / 2)
    y = a[mid]
    if (x == y) break
    if (x <  y) {hi=mid-1} else {lo=mid+1} 
  } while (lo <= hi) 
  return mid }

function main(i,s) {
  Some(s)
  #for(i=30000;i>=1;i--) {
  for(i=1;i<=100000;i++) {
     if(!(i%100)) SomeReady(s)
     SomeAdd(s,i) #rand()) 
  }
  SomeReady(s)
  #for(i=1;i<=length(s.all);i++) print ":",s.all[i] 
}

BEGIN {
  srand(ENVIRON["R"]?ENVIRON["R"]:1)
  main()
  rogues()
}
