@include "lib.awk"
@include "tiles.awk"

function _contrast(   _Tables,t,centers,pairs,
                      what,better) {
  t=0
  readcsv("data/nasa93dem.csv",t,_Tables)
  centers= tiles(_Tables,t)
  what[colnums[centers]["$_XX"]]
  what[colnums[centers]["$_YY"]]
  
  neighbors0(_Tables[centers],pairs,what,1)
    #o(indeps[centers],"indep")
   o(pairs,"pairs")
  tableprint(_Tables[centers],"%.6g")
  deltas(_Tables,centers,pairs,better)
  o(better,"better")
#   for(name in names) {
 #   print "\n-----| "name" |-----------------------------------"
  #  tableprint(_Tables[name],"%.6g")
   #}
  #print "centroids",length(datas[centers])
  
}
#better[200]
#|   [300] = (0.10281) means make 200 better by going to 300

function deltas(_Tables,mid,pairs,better,
		hell,table,tiny,from,tmp,table1,table2,to) {
  hell = colnums[mid]["$_Hell"]
  table  = colnums[mid]["_ZZ"]
  tiny = 0.3 * sds[mid][hell]
  for(from in pairs) 
    delta1(length(pairs[from]),
	   pairs,hell,from,mid,tiny,datas,tmp)   
 for(from in tmp)
  for(to in tmp[from]) {
    table1 = datas[mid][from][table]
    table2 = datas[mid][to][table]
     better[table1][table2] = tmp[from][to]
     }
}
function delta1(max,pairs,hell,from,mid,tiny,datas,better,
		i,to,hell1,hell2) {
  hell1 = datas[mid][from][hell]
  for(i=1;i<=max;i++) {
    to     = pairs[from][i]["to"]
    hell2  = datas[mid][to][hell]
    if (abs(hell2 - hell1) > tiny)
      if (hell2 > hell1) 
	return better[from][to] = hell2 - hell1
  }}
