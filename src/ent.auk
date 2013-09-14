function incE(v,k,_Ent,r) {
  r = r ? r : 1
  label[k]  = 0
  n[k] += r
  count[k][v] += r
}
function entE(k,_Ent,   v,p,out) {
  for(v in count[k]) {
    p    = count[k][v]/n[k]
    out -= p*log(p)/log(2)
  }
  return out
}
function copyE(_Ent1,_Ent2,   k) {
  for(k in count1) 
    for(v in count1[k]) 
      incE(v,k,_Ent2,count1[k,v])
}    
function addE(_Ent1,_Ent2,_Ent3) {
  copyE(_Ent1,_Ent3)
  copyE(_Ent2,_Ent3)
}


# sunny		,85		,85		,FALSE	,no
# overcast	,83		,86		,FALSE	,yes
# overcast	,81		,75		,FALSE	,yes
# sunny		,80		,90		,TRUE	,no
# rainy		,75		,80		,FALSE	,yes
# sunny		,75		,70		,TRUE	,yes
# sunny		,72		,95		,FALSE	,no
# overcast	,72		,90		,TRUE	,yes
# rainy		,71		,91		,TRUE	,no
# rainy		,70		,96		,FALSE	,yes
# sunny		,69		,70		,FALSE	,yes
# rainy		,68		,80		,FALSE	,yes
# rainy		,65		,70		,TRUE	,no
# overcast	,64		,65		,TRUE	,yes





