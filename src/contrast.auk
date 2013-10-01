@include "lib.awk"
@include "tiles.awk"

function _contrast(   _Tables,t,centers,pairs,
                      what,better,worse) {
  t=0
  readcsv("data/nasa93dem.csv",t,_Tables)
  centers= tiles(_Tables,t)
  what[colnums[centers]["$_XX"]]
  what[colnums[centers]["$_YY"]]
  neighbors0(_Tables[centers],pairs,what,1)
  tableprint(_Tables[centers],"%.6g")
  deltas(_Tables,what,centers,pairs,better,worse)
  o(better,"better1")
  o(worse,"worse1")
}

function deltas(_Tables,what,mid,pairs,better,worse,
		hell,table,tiny,from,tmp0,tmp1,table1,table2,to) {
  #hell = colnums[mid]["$_Hell"]
  table  = colnums[mid]["_ZZ"]
  #tiny = 0.3 * sds[mid][hell]
  for(from in pairs) 
    dominates(length(pairs[from]),what,pairs,from,_Tables[mid],tmp0,tmp1)
  join2table(tmp0,better,datas,mid,table)
  join2table(tmp1,worse, datas,mid,table)
}
function join2table(lst,out,datas,mid,table,    from,to,table1,table2) {
 for(from in lst)
  for(to in lst[from]) {
    table1 = datas[mid][from][table]
    table2 = datas[mid][to][table]
    out[table1][table2] = lst[from][to]
  }
}
function dominates(max,what,pairs,from,_Table,better,worse,
                 i,to,diff,space,b4) {
  for(i=1;i<=max;i++) {
    to   = pairs[from][i]["to"]
    space= dist0(data[from],data[to],what,_Table)
    diff = dominate(from,to,_Table)
    if (diff > 0) {
      b4 = priorD(better,from,1000000)
      if (space < b4) 
	{delete better[from]; better[from][to] = space}
      b4 = priorD(worse,to,100000)
      if (space < b4)
	{delete worse[to]; worse[to][from] = space} 
}}}

function priorD(lst,x,z,   y) {
  if (x in lst) {
    for(y in lst[x])
      return lst[x][y] 
  } else
    return z
}
 
function dominate(from,to,_Table, 
		  k,delta,inc,tiny,diff,good) {
  for(k in less) 
    delta[k] = data[from][k] - data[to][k]
  for(k in more) 
    delta[k] = data[to][k] - data[from][k]
  for(k in delta) {
    diff = delta[k]
    inc = diff/(hi[k] - lo[k]) 
    tiny = 0.3 * sd[k]
    if (diff < -1*tiny) 
      return 0
    if (diff > tiny)
      good += inc
  }
  return good / sqrt(length(delta))
}
