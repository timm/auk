@include "lib.awk"
 
#

function obs(f,all,_Nums,_Div,   now,i,v)  {
  now = all
  while((getline  < f ) > 0) {
    for(i=1;i<=NF;i++) 
      if ($i ~ /^([^0-9]|\.)/) 
	now = $i
      else {
	v = $i+0
	inc(v, now,_Nums)
	inc(v, all, _Nums)
      }}
  close(f)
  for(i in names) 
    if (i != all) {
      order[i]["="] = i
      order[i]["x"] = mus[i]
    }
  asort(order,order,"xsort")
}
function inc(v,k,_Num,   all,delta) {
  name[k]
  label[k]  = 0
  all       = ++n[k]
  x[k][all] = v
  sum[k]   += v
  delta     = v - mu[k]
  mu[k]    += delta/all
  m2[k]    += delta*(v - mu[k])
  var[k]    = m2[k]/ (all - 1 + PINCH)
}
function _rank(    a) {
  args("-d,data/skb.txt,-cohen,0.3,--mittas,1,-a12,0.6",a)
  ranks("data/ska.txt",a)
  ranks("data/skb.txt",a)
  ranks("data/skp.txt",a)
  ranks("data/skc.txt",a)
  ranks("data/skd.txt",a)
  ranks("data/ske.txt",a)
 }
 function ranks(f,a,    _Nums,_Div,i,k,max) {
   print "\n----|", f,"|---------------------"
   obs(f,0,_Nums,_Div)
   rank(0,_Nums,_Div,a)
   max = length(order)
   for(i=1;i<=max;i++) {
     k = order[i]["="]
     print k, names[k], ":mu", mus[k], ":rank",labels[k] }
 }
 function rank(all,_Nums,_Div,a,    i) {
     cohen  = a["-cohen"]*sqrt(vars[all])
     mittas = a["--mittas"]
     a12    = a["-a12"]
     level  = 0
     total  = ns[all]
     rdiv(1,length(order),1,_Nums,_Div)
 }
 function rdiv(lo,hi,c,_Nums,_Div,    i,cut) {
     cut = div(lo,hi,_Nums,_Div)
     if (cut) {
       level++
       c = rdiv(lo,cut-1,c, _Nums,_Div) + 1
       c = rdiv(cut,hi  ,c, _Nums,_Div)
     } else 
	 for(i=lo; i<=hi; i++) 
	     labels[order[i]["="]] = c
     return c
 }
 function div(lo,hi,_Nums,_Div,   
		_Num0, _Num1,max,b,i,left,
		muLeft,right,muRight,e,cut,
		muAll ) {
   muAll = divInits(lo,hi,_Nums,_Div,_Num0,_Num1)
   max   = -1
   for(i=lo+1;i<=hi;i++) {
     b       = order[i]["="]
     n0[i]   = n0[i-1]   + ns[b]
     sum0[i] = sum0[i-1] + sums[b] 
     left    = n0[i] 
     muLeft  = sum0[i]  / left
     right   = n1[i]
     muRight = sum1[i]  / right
     e = errDiff(muAll,left,muLeft,right,muRight)
     if (cohen)
       if (abs(muLeft - muRight) <= cohen)
	 continue
     if (mittas) 
       if (e < max)
	 continue
     if (a12)
       if(bigger(lo,i,hi,_Nums,_Div) < a12)
	 continue
     max = e
     cut = i
   }	
   return cut 
 }
function divInits(lo,hi,_Nums,_Div,_Num0,_Num1,   b,i) {
  b= order[lo]["="]; n0[lo]= ns[b]; sum0[lo]= sums[b];
  b= order[hi]["="]; n1[hi]= ns[b]; sum1[hi]= sums[b]
  for(i=hi-1; i>=lo;  i--) {
     b       = order[i]["="]
     n1[i]   = n1[i+1]   +  ns[b]
     sum1[i] = sum1[i+1] +  sums[b]
   }
  return sum1[lo]/n1[lo]
}
function errDiff(mu,n0,mu0,n1,mu1) {
  return n0*(mu - mu0)^2 + n1*(mu - mu1)^2
}
function bigger(lo,mid,hi,_Nums,_Div, 
		below,above,i,j,m,more,same) {
  values(below, lo,   mid-1, _Nums,_Div)
  values(above ,mid,  hi, _Nums,_Div)
  for(j in above) 
    for(i in below) {
      m++
      more += above[j] >  below[i]
      same += above[j] == below[i]
    }
  return (more + 0.5*same)/m
}
function values(out,i,j,_Nums,_Div,   k,b,l,m) {
  for(k=i;k<=j;k++) {
    b = order[k]["="]
    for (l in xs[b]) 
      out[++m] = xs[b][l]
  }
  return m
}
