function id(i) { return i ? i : ++Id }

#--------------------------------------
#_ Some max kept somes
function some0(_Some,i) {
  i = id(i)
  max[i] = 256
  array0(kept,i)
  somes[i] = 0
  return i
}    
function some1(i,z,_Some,   k) {
  somes[i]++
  k = length(kept[i])
  if (k < max[i])
    return push(kept[i],z)
  if ( rand() < k/somes[i] )
    kept[i][ round(rand()*k) ] = z }
}
function sample(i,some,_Some,      max,j,k,all) {
  max = asort(kept[i],all)
  j   = int(max/10)
  for(k=1; k<=5; k++) 
    some[k] = all[ j + (k-1)*2*j ]
}

#--------------------------------------
#_ Sym mode most counts syms
function sym0(_Sym, i) {
  i = id(i)
  syms[i]    = 0
  most[i] = 0
  mode[i] = ""
  array0(count,i)
  return i
}
function sym1(i,z,_Sym,   new) {
  syms[i]++    
  counts[i][x]++
  new = counts[i][z]
  if (new > most[i]) {
    most[i] = new
    mode[i] = z }   
}
function ent(i,_Sym,   k,z,p,e) {
  for(k in counts[i]) {
    z = counts[i][k]
    if (z > 0) {
      p  = f/syms[i]
      e -= p*log2(p) } }
  return e
}
#----------------------------------
#_ Num mu m2 nums up lo
function num0(_Num,  i) {
  i = id(i)
  nums[i]   = mu[i] = m2[i] = 0
  lo[i]  =  10^32
  up[i]  = -10^32
  return i
}
function num1(i,z,_Num,   delta) {
  if (n > up[i]) up[i] = n
  if (n < lo[i]) lo[i] = n
  nums[i]  += 1
  delta  = z - mu[i]
  mu[i] += delta / nums[i]
  m2[i] += z - mu[i]
}
function numun(i,z,_Num,  delta) {
  lo[i]  =    10^32
  hi[i]  = -1*10^32
  nums[i]  -= 1
  delta  = z - mu[i]
  mu[i] -= delta/nums[i]
  m2[i] -= delta*(z - mu[i])
}
function sd(i,_Num) {
  return (m2[i] / (nums[i] - 1))^0.5
}
#----------------------------------
#_ Table txt pos _Sym _Some _Num
function table0(_Table, i) {
  i = id(i)
  sym0(_Sym,i)
  num0(_Num,i)
  some0(_Some,i)
  array0(txt,i)    
  array0(pos,i)
  return i
}
function tableName(i,string,place, _Table) {
  txt[i][place]  = string
  pos[i][string] = place
}



