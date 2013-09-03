@include "lib.awk"
 
function obs(f,all,_Nums,_Div,   now,i,v)  {
  now = all
  while((getline  < f ) > 0) {
    for(i=1;i<=NF;i++) 
      if ($i ~ /^([^0-9]|\.)/) 
	now = $i
      else {
	print "[",v,"]"
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

function _rank() {
  ranks("sk1.txt")
  ranks("sk1.txt")
  ranks("sk0.txt")
}
function ranks(f,    _Nums,_Div,i,k,max) {
  print "\n----|",f,"|---------------------"
  obs(f,0,_Nums,_Div)
  rank(0,_Nums,_Div)
  max = length(order)
  for(i=1;i<=max;i++) {
    k = order[i]["="]
    print k, names[k], ":mu", mus[k], ":rank",labels[k] }
}
function rank(all,_Nums,_Div,    i) {
    tiny = 0.3*sqrt(vars[all])
    level = 0
    total = ns[all]
    div(1,length(order),1,_Nums,_Div)
}
function bars(x) { return nchars(x,"|-- ") }
function div(lo,hi,c,_Nums,_Div,    i,cut) {
    print bars(level) ":lo",lo,":hi",hi,":c",c
    cut = slice(lo,hi,_Nums,_Div)
    if (cut) {
      print bars(level)"cutting",lo,"to",cut - 1,"then",cut,"to",hi
      level++
      c = div(lo,cut-1,c, _Nums,_Div) + 1
      c = div(cut,hi  ,c, _Nums,_Div)
    } else {
	for(i=lo; i<=hi; i++) 
	    labels[order[i]["="]] = c
    }
    return c
}
function slice(lo,hi,_Nums,_Div,   
	       _Num0, _Num1,max,b,i,left,
	       muLeft,right,muRight,e,cut,
               muAll ) {
     b = order[lo]["="] ; n0[lo] = ns[b]; sum0[lo] = sums[b]; 
     b = order[hi]["="] ; n1[hi] = ns[b]; sum1[hi] = sums[b]
     for(i=hi-1; i>=lo;  i--) {
       b       = order[i]["="]
       n1[i]   = n1[i+1]   +  ns[b]
       sum1[i] = sum1[i+1] +  sums[b]
     }
     max = -1
     muAll = sum1[lo]/n1[lo]
     for(i=lo+1;i<=hi;i++) {
       print bars(level) "considering",i,order[i]["="]
       b      = order[i]["="]
       n0[i]  = n0[i-1]   + ns[b]
       sum0[i]= sum0[i-1] + sums[b] 
       left    = n0[i]
       right   = n1[i]
       muLeft  = sum0[i]  / left
       muRight = sum1[i]  / right
       e = left*(muAll - muLeft)^2 + right*(muAll - muRight)^2	
       if (abs(muLeft - muRight) > tiny && e >  max) {
	 max = e
	 cut = i
	 print bars(level) "cut",cut
	 print bars(level)":cut",cut,":max",max,":muLeft",muLeft,	\
	                ":muRight",muRight
       }
	print  bars(level)":tiny",tiny,":max",max,":e",e,			\
	  ":b",b,":left",left,":right",right,	\
	  ":muLeft",muLeft,":muRight",muRight,":muAll",muAll
	
      }
     if(level==1) {
       o(sum0,"sum0")
       o(sum1,"sum1")
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
