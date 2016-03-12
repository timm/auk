@include "lib.awk"
@include "reader.awk"
@include "labels.awk"
@include "ent.awk" 

function _sdiscrete(    _Table,bins,tiny,f,t1) {
  #f="data/weather3.csv";  bins = 3
  f="data/diabetes.csv";  bins = 3 
  #f="data/weather4.csv";  bins = 4
  # f="data/weather5.csv";  bins = 2
  #f="data/weather6.csv";  bins = 3
  print(">> ",f)
  readcsv(f,0,_Table)
  tiny=0.3
  t1 = sdiscrete(_Table, 0, bins, tiny)
  tableprint(_Table[0],"%.4g")
  tableprint(_Table[t1])
}

function sdiscrete(_Table,t,bins,tiny,  t1,newNames,b) {
  t1="D_ t"
  ewdbreaks(b)
  discreteNames(name[t],num[t],newNames)
  makeTable(newNames, t1, _Table)
  sdiscrete1(_Table[t],_Table[t1],tiny,bins)
  
  return t1
}
function sdiscrete1(_Table0,_Table1,tiny,bins,
		   k,breaks,i,j) {
  new(breaks)
  for(k in num0) 
    sdiscrete2(k,_Table0,tiny,bins,breaks)
  slabels(_Table0,_Table1,breaks)
  #o(breaks,"breaks" k)
  
}

function slabels(_Table,_Table1,breaks,
                max,d,k,val,a) {
  max = length(data)
  for(d=1;d<=max;d++) {
    for(k in name) {
      val = data[d][k]
      if (val != "?")
	if(k in num)
	  val = slabel(val,breaks[k])
      a[k] = val
    }
    addRow(a,_Table1) 
}}
    
function slabel(val,b,   bins,i,last) {
  
  bins = length(b) + 1
  if(bins==1)
    return 1
  for(i=1;i < bins;i++)  {
    if(i in b) {
      last = b[i]
      if (val <= b[i]) 
	return "<="b[i]
  }}
  return ">"last #b[length(bins)]
}
function sdiscrete2(k,_Table0,tiny,bins,breaks,
                    _Ent,cut1,cut2,d,key,val,i,keys,max,breaks0) {
  cut1 = (hi0[k] - lo0[k])/bins
  cut2 = tiny * sd0[k]
  if (cut1 < cut2) cut1 = cut2
  print k,name0[k],cut1,cut2
  for(d in data0) {
    key  = int(data0[d][k]/cut1)*cut1
    if (key > hi0[k])
      key=  key - cut1 # handle last number max problem
    if (key < lo0[k])
      key = key + cut1
    keys[key] = key
    val  = klass1(d,_Table0)
    incE(val,key,_Ent) }
  max=asort(keys,order)
 level = 0
  rEntDiv(1,length(order),1,_Ent)
  for(i=1;i<= max;i++) {
    breaks0[k][i]["x"] = order[i]
    breaks0[k][i]["="] = labels[order[i]]
  }
  packBreaks(k,breaks0,breaks)
}
function packBreaks(k,breaks0,breaks,   i,max,m){
 max = length(breaks0[k])
  for(i=1;i<max;i++)  
    if (breaks0[k][i]["="] != breaks0[k][i+1]["="])
      breaks[k][++m] = breaks0[k][i+1]["x"] 
}
function rEntDiv(lo,hi,c,_Ent,    i,cut) {
  cut = entDiv(lo,hi,_Ent)
  if (cut) {
    level++
    c = rEntDiv(lo,cut-1,c,_Ent) + 1
    c = rEntDiv(cut,hi  ,c,_Ent)
  } else 
    for(i=lo; i<=hi; i++) 
      labels[order[i]] = c
  return c
}
function entDiv(lo,hi,_Ent,
		_Ent0,_Ent1,
		min,i,k,left,e0,right,e1,e,cut,v,vs,all) {
  allv(_Ent,vs) #<== must find all symbols
  min = entDivInit(lo,hi,_Ent,_Ent0,_Ent1,vs)
  for(i=lo+1;i<=hi;i++) {
    k     = order[i]
    left  = n0[i-1]
    e0    = entE(i-1,vs,_Ent0)
    right = n1[i]
    e1    = entE(i,vs,_Ent1)
    all   = left + right
    e     = left/all * e0 + right/all * e1 #<== must div on all
    if( e < min) {
      min = e
      cut = i
    }
    n0[i] = n0[i-1] + n[k]
    for(v in vs)
      count0[i][v] += count0[i-1][v] + count[k][v]
  }
  return cut
}
function allv(_Ent,vs,   k,v) {
  for(k in count)
    for(v in count[k])
      vs[v]
}
function entDivInit(lo,hi,_Ent,_Ent0,_Ent1,vs,
                   k,v,i) {
  k = order[hi]; n1[hi] = n[k];  
  for(v in vs) 
    count1[hi][v] = count[k][v]
  for(i=hi-1; i>=lo;  i--) {
    k     = order[i]
    n1[i] = n1[i+1] + n[k]
    for(v in vs) 
      count1[i][v] = count1[i+1][v] + count[k][v]
    }
  k = order[lo]; n0[lo] = n[k];  
  for(v in vs) 
    count0[lo][v] = count[k][v]
  return entE(lo,vs,_Ent1)
}
