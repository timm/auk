function dist(i,j,  sum,n,k,v1,v2){
  for(k in Num) {
    v1 = Data[i][k]; v2 = Data[j][k]; n += 1
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else {
      if (v1 != "?") 
	v1= (v1- Lo[k]) / (Hi[k]- Lo[k]+ 0.001)
      if (v2 != "?") 
	v2= (v2- Lo[k]) / (Hi[k]- Lo[k]+ 0.001)
      if (v1 == "?") v1= v2 < 0.5 ? 1 : 0
      if (v2 == "?") v2= v1 < 0.5 ? 1 : 0
      sum += ((v2 - v1)^2) }}
  for(k in Term) {
    v1 = Data[i][k]; v2 = Data[j][k]; n += 1
    if (v1 == "?" && v2 == "?") 
      sum += 1
    else {
      if      (v1 == "?") sum += 1
      else if (v2 == "?") sum += 1
      else if (v1 != v2 ) sum += 1 }}
  return sum^0.5 / n^0.5
}
function closest(i,   d,least,out,j) {
  least = 1.1
  for(j in Data)
    if (j != i) 
      if (( d = dist(i,j)) < least) { 
	least= d; out= j }
  return out
}
function furthest(i,   d,most,out,j) {
  most = 0
  for(j in Data)
    if (j != i)
      if ((d = dist(i,j)) > most) { 
	most = d; out = j }
  return out
}
