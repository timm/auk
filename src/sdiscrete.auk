@include "lib.awk"
@include "reader.awk"
@include "labels.awk"
@include "ent.awk" 

function _sdiscrete(_Table,b,bins,newNames,i,
                   labels,tiny) {
  readcsv("data/weather2.csv",0,_Table)
  labels="ewdlabel"
  ewdbreaks(b)
  tiny=0.3
  bins = 3
  discreteNames(name[0],newNames)
  makeTable(newNames, 1, _Table)
  sdiscrete(_Table[0],_Table[1],tiny,bins,b[bins],labels)
  #tableprint(_Table[1])
}

function sdiscrete(_Table0,_Table1,tiny,bins,b,labels,
		   _Ents,k) {
  for(k in num0) 
    return sdiscrete1(k,_Table0,_Ents,tiny,bins)
}
function sdiscrete1(k,_Table0,_Ent,tiny,bins,
                    cut1,cut2,d,key,val) {
  cut1 = (hi0[k] - lo0[k])/bins
  cut2 = tiny * sd0[k]
  if (cut1 < cut2) cut1 = cut2
  for(d in data0) {
    key  = int(data0[d][k]/cut1)*cut1
    keys[key] = key
    val  = klass1(d,_Table0)
    incE(val,key,_Ent) }
  asort(keys,order)
  return 
  level = 0
  rEntDiv(1,len(order),1,_Ent)
  o(count,"count " k)
}
function rEntDiv(lo,hi,c,_Ent,    i,cut) {
  cut = entDiv(lo,hi,_Ent)
  if (cut) {
    level++
    c = rEntDiv(lo,cut-1,c, _Ent) + 1
    c = rEndDiv(cut,hi  ,c, _Ent)
  } else 
    for(i=lo; i<=hi; i++) 
      labels[order[i]] = c
  return c
}
function entDiv(lo,hi,_Ent,
                    _Ent0,_Ent1) {
  entDivInit(lo,ho,_Ent,_Ent0,_Ent1)
  o(counts1,"counts1")
  o(n1,"n1")
  min = 10^32
  for(i=lo+1;i<=hi;i++) {
    k     = order[i]
    n0[i] = n0[i-1] + n[k]
    for(v in count[k])
      count0[i][v] += count0[i-1][v] + count[k][v]
    left  = n0[i]
    e0    = entE(i,_Ent0)
    right = n1[i]
    e1    = entE(i,_Ent1)
    e     = left * e0 + right * e1 
    if( e < min) {
      min = e
      cut = i
    }}
  return cut
}
function entDivInit(lo,hi,_Ent,_Ent0,_Ent1,
                   k,v,i) {
  k = order[lo]; n0[lo] = n[k];  
  for(v in count[k]) 
    count0[lo][v] = count[k][v]
  k = order[hi]; n1[hi] = n[k];  
  for(v in count[k]) 
    count1[hi][v] = count[k][v]
  for(i=hi-1; i>=lo;  i--) {
    k       = order[i]
    n1[i] = n1[i+1] + n[k]
    for(v in count[k]) 
      count1[i][v] = count1[i+1][v] + count[k][v]
}}
