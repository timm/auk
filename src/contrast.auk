@include "lib.awk"
@include "tiles.awk"
@include "sdiscrete.awk"
@include "bore.awk"

function _contrast(   _Tables,t,centers,pairs,
                      what,better,worse,cache,x,to,from,todo) {
  t=0
  readcsv("data/nasa93dem.csv",t,_Tables)
  centers= tiles(_Tables,t)
  what[colnums[centers]["$_XX"]]
  what[colnums[centers]["$_YY"]]
  #tableprint(_Tables[centers],"%.2g")
  #tableprint(_Tables[500],"%.2g")
  #tableprint(_Tables[700],"%.2g")
  deltas(_Tables[centers],what,better,worse,cache)
  o(better,"better")
  #o(worse,"worse")
  #contrast1(1,2,centers,_Tables)
  #contrast1(2,3,centers,_Tables)
  contrast1(3,8,centers,_Tables)
  #contrast1(4,6,centers,_Tables)
  #contrast1(5,9,centers,_Tables)
  #contrast1(6,8,centers,_Tables)
}
BEGIN {CID=0}
function contrast1(from0,to0,centers,_Tables,
                   adds,wider,space,d,from,join,to,t1,
                   yes,no,want,all,skip,good,m, best,i) {
  join = colnums[centers]["_ZZ"]
  from = datas[centers][from0][join]
  to   = datas[centers][to0][join]
  #print join,from0,from,to0,to
  copy(names[centers],adds)
  push("=contrast",adds)
  space = makeTable(adds,newTableName(_Tables),_Tables)
  CID++ 
  yes = CID 0
  no  = CID 1
  for(d in datas[from]) {
    copy(datas[from][d],wider)
    push(no,wider)
    addRow(wider,_Tables[space]) }
  for(d in datas[to]) {
    copy(datas[to][d],wider)
    push(yes,wider)
    addRow(wider,_Tables[space]) }
  t1 = sdiscrete(_Tables,space,4,0.3)
  tables(_Tables[t1],_Tables)
  print("envied =" to0);   tableprint(_Tables[yes],"%.2g")
  print("feared =" from0);    tableprint(_Tables[no],"%.2g")
  want=yes
  all[yes]
  all[no]
  skip[colnums[t1]["_XX"]]
  skip[colnums[t1]["_YY"]]
  skip[colnums[t1]["_ZZ"]]
  skip[colnums[t1]["_Hell"]]
  skip[colnums[t1]["_contrast"]]
  skip[colnums[t1]["center"]]
  m=bore(_Tables,all,want,0.5,good,skip)
  o(good,"good")
  forwardSelect(length(datas[want]),-1,1,m,all,want,good,_Tables,best,0.66)
  o(best,"best")
  for(i in best)
    print i,names[t1][i]

  #exit
}
function deltas(_Table,what,better,worse,cache,
		good,bad,d1,d2,old,good1,bad1) {
  for(good in data)
    for(bad in data)
      if(good > bad) 
	if (dominated(bad,good,_Table)) {
	  good1 = good
	  bad1  = bad
	  if (bad in better) 
	    good1 = nearest(bad,good,better[bad],_Table,what,cache)
	  if (good in worse) 
	    bad1  = nearest(good,bad,worse[good],_Table,what,cache)
	  better[bad] = good1
	  worse[good] = bad1
	}}

function nearest(from,old,maybe,_Table,what,cache,   d1,d2) {
  d1 = gap(from,old,  _Table,what,cache)
  d2 = gap(from,maybe,_Table,what,cache)
  return d2 < d1 ? maybe : old
}
function gap(d1,d2,_Table, what,cache,   tmp) {
  if ((d1,d2) in cache)
    return cache[d1,d2]
  tmp = dist0(data[d1],data[d2],what,_Table,1)
  cache[d1,d2]= cache[d2,d1] = tmp
  return tmp
}
function dominated(from,to,_Table, 
		  k,delta,tiny,diff,good) {
  for(k in less) 
    delta[k] = data[from][k] - data[to][k]
  for(k in more) 
    delta[k] = data[to][k] - data[from][k]
  for(k in delta) {
    diff = delta[k]
    tiny = 0.3 * sd[k]
    if (diff < -1*tiny) 
      return 0
    if (diff > tiny)
      good += diff/(hi[k] - lo[k]) 
  }
  return good / sqrt(length(delta))
}
function join2table(lst0,lst,_Table,   x,y,z,table) {
  table  = colnum["_ZZ"]
  for(x in lst0) {
    y = data[x      ][table]
    z = data[lst0[x]][table]
    lst[y] = z
}}
