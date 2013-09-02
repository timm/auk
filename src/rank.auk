@include "lib.awk"
 
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
function _rank(    _Nums,_Div,i,k,max) {
  obs("data/sk1.txt",0,_Nums,_Div)
  rank(0,_Nums,_Div)
  max = length(order)
  for(i=1;i<=max;i++) {
    k = order[i]["="]
    print k, names[k], ":mu", mus[k], ":rank",labels[k] }
}
function rank(all,_Nums,_Div,    i) {
    tiny = 0.3*sqrt(vars[all])
    level = 0
    div(1,length(order),1,_Nums,_Div)
}
function div(lo,hi,c,_Nums,_Div,    i,cut) {
    print nchars(level,"|-- ") ":lo",lo,":hi",hi,":c",c
    cut = slice(lo,hi,_Nums,_Div)
    if (cut) {
        level++
	c = div(lo,cut,c, _Nums,_Div) + 1
	c = div(cut+1,hi  ,c, _Nums,_Div)
    } else {
	for(i=lo; i<=hi; i++) 
	    labels[order[i]["="]] = c
    }
    return c
}
function slice(lo,hi,_Nums,_Div,   
	       _Num0, _Num1,min,b,i,left,
	       muLeft,right,muRight,e,cut,
               b0,b1,muAll ) {
    if (lo >= hi) return 0
    b = order[lo]["="]; n0[b] = ns[b]; sum0[b] = sums[b]
    b = order[hi]["="]; n1[b] = ns[b]; sum1[b] = sums[b]
    for(i=hi-1; i>=lo;  i--) {
      b0       = order[i]["="]
      b1       = order[i+1]["="]
      n1[b0]   = n1[b1]   +  ns[b0]
      sum1[b0] = sum1[b1] +  sums[b0]
    }
    min    = 10**32
    b      = order[lo]["="];  muAll = sum1[b]/n1[b]
    for(i=lo+1;i<=hi;i++) {
       b0      = order[i-1]["="]
       b1      = order[i]["="]
       n0[b1]  = n0[b0]   + ns[b1]
       sum0[b1]= sum0[b0] + sums[b1] 
       left    = n0[b0]
       right   = n1[b1]
       muLeft  = sum0[b0]  / left
       muRight = sum1[b1]  / right
       e = left*(muAll - muLeft)^2 + right*(muAll - muRight)^2	
       if (abs(muLeft - muRight) > tiny && e <  min) {
	 min = e
	 cut = i 
	 print ":cut",cut,":min",min,":muLeft",muLeft,":muRight",muRight
       }
       print  ":tiny",tiny,":min",min,":e",e,\
             ":b0",b0,":b1",b1,":left",left,":right",right,\
             ":muLeft",muLeft,":muRight",muRight,":muAll",muAll
	    
    }
    return cut 
}

function bigger(x,b,lo,hi,  
		i,j,k,l,v1,v2,less,same) {
    for(i=lo;i<=b;i++) 
	for(j in x[i])  {
	    v1 = x[i][j]
	    for(k=b+1;k<=hi;k++) 
		for(l in x[k]) {
		    v2    = x[k][l]
		    less += v1 > v2 
		    same += v2 == v1 }
    }
    return less + 0.5*same
}
