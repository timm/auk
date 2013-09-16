@include "lib.awk"
@include "reader.awk"
@include "labels.awk"
@include "ent.awk" 

function _sdiscrete(_Table,b,bins,newNames,i,
                   labels,tiny,f) {
  f="data/weather6.csv"
  print(">> ",f)
  readcsv(f,0,_Table)
  labels="ewdlabel"
  ewdbreaks(b)
  tiny=0.3
  bins = 3
  discreteNames(name[0],num[0],newNames)
  
  makeTable(newNames, 1, _Table)
  sdiscrete(_Table[0],_Table[1],tiny,bins)
  tableprint(_Table[0])
  tableprint(_Table[1])
}

function sdiscrete(_Table0,_Table1,tiny,bins,
		   k,breaks) {
  for(k in num0) 
    print "\n" sdiscrete1(k,_Table0,tiny,bins,breaks)
  slabels(_Table0,_Table1,breaks)
}
function slabels(_Table,_Table1,breaks,
                max,d,k,val,a) {
  max = length(data)
  print "max",max
  for(d=1;d<=max;d++) {
    for(k in name) {
      val = data[d][k]
      if (val != "?")
	if(k in num)
	  val = slabel(val,k,breaks[k])
      a[k] = val
    }
    addRow(a,_Table1) 
}}
    
function slabel(val,k,breaks,    max,i,last,this){
  max = length(breaks);print val, "mmax",max
  o(breaks,"breaks")
  last = -1*10^32
  if (max == 1) return 1
  for(i=1;i <= max;i++) {
    if(k==2)
      print ":k",k,":i",i,":max",max,":val",val,":b",breaks[i]["x"]
    if (i < max && breaks[i]["="] == breaks[i+1]["="]) {      
      o(breaks,"breaks11"); 
      continue
    }
    this = breaks[i]["x"]
    print "======> :last",last,":this", this,":val",val,":=",breaks[i]["="]
    if (val >= last && val <= this) {
      if (k==2)
	print "xxx",val,"=",breaks[i]["="]
      return breaks[i]["="]
    }
    last = this
  }
 return  breaks[max]["="]
}
function sdiscrete1(k,_Table0,tiny,bins,breaks,
                    _Ent,cut1,cut2,d,key,val,i,keys,max) {
  cut1 = (hi0[k] - lo0[k])/bins
  cut2 = tiny * sd0[k]
  if (cut1 < cut2) cut1 = cut2
  for(d in data0) {
    key  = int(data0[d][k]/cut1)*cut1
    keys[key] = key
    val  = klass1(d,_Table0)
    incE(val,key,_Ent) }
  max=asort(keys,order)
  level = 0
  rEntDiv(1,length(order),1,_Ent)
  o(labels,"label "k)
  for(i=1;i<= max;i++) {
    breaks[k][i]["x"] = order[i]
    breaks[k][i]["="] = labels[order[i]]
  }
}
function rEntDiv(lo,hi,c,_Ent,    i,cut) {
  cut = entDiv(lo,hi,_Ent)
  #print nchars(level,".."),":lo",lo,":hi",hi,":cut",cut
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
  #if (lo>=hi) return 0
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
    #print nchars(level,".."),":i",i,":k",k,":min",min,":left",left,":e0",e0,\
                       #      ":right",right,":e1",e1,":e",e,":cut",cut
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
