@include "args.awk"

#  

 BEGIN { 
         _     = SUBSEP 
         Q     = "\"" 
         PI    = 3.1415926535
         EE    = 2.7182818284 
         INF   = 10^17
	 NINF  = -1*INF
         PINCH = 1 / INF
       }

function norm(x,m,s) {
    s = s + PINCH
    return 1/sqrt(2*PI*s^2)*EE^(-1*(x-m)^2/(2*s^2))
 }
function adda(a1,a2, i){ 
  for(i in a1) a2[i] += a1[i] 
}
function adda2(k1,a1,k2,a2, i){ 
  for(i in a1[k1]) 
    a2[k2][i] += a1[k1][i] 
}
function pairs(str,lst,   i,tmp,n) {
  split("",lst,"")
  n=split(str,tmp,",")
  for(i=1;i<n;i+=2)
    lst[tmp[i]]=tmp[i+1]
}
function l2s(l,sep,form,   one,sep1,s,n,i) {
    form = form ? form : "%5.3f"
    s=""
    n=length(l)
    for(i=1;i<=n;i++)  {
        one = l[i]
        if (numberp(one)) 
	    one = sprintf(form,one)
	s = s sep1 one
        sep1 = sep
    }
    return s 
}
function indexes(lst,out,    i) {
  new(out)
  for(i in lst) 
    out[i]=i
  return length(out)
}

function shuffle(lst) {
  asort(lst,lst,"rsort")
}
function numberp(x) {
  return x=="" ? 0 : x == (0+strtonum(x))
}
function barph(x) {
  printf("#E> " x "\n")>"/dev/stderr"
  fflush("/dev/stderr")
  return 0
}
function resetSeed(seed) {
  if      (seed) srand(seed)
  else if (SEED) srand(SEED)
  else           srand(1)
}
function push(x,a,  i) {
  i = 1 + length(a)
  a[i] = x
  return i
}
function pop(a,    i,j) {
  i = length(a)
  j = a[i]
  delete a[i]
  return j
}
function xsort(r1,x1,r2,x2) { return x1["x"] - x2["x"] }
function ysort(r1,x1,r2,x2) { return x1["y"] - x2["y"] }
function rsort(r1,x1,r2,x2) { return (2 - 4 * rand())  }

function line(f,   str) {
  if ((getline str < f) > 0) {
    gsub(/[ \t\r]*/,"",str) 
    gsub(/#.*$/,"",str)
    if ( str ~ /,[ \t]*$/ )
      return str line(f)
    else
      return str 
  } else
    return -1
}
function new2d(a,b)   { a[b][""]; delete a[b][""] }
function new3d(a,b,c) { a[b][c][""];  delete a[b][c] }
function new(a) {
  split("",a,"")
}
function isnum(x) { 
  return x=="" ? 0 : x == (0+strtonum(x)) 
}
function abs(x) { return x < 0 ? -1*x : x }
function appendn(a1,a2,a3,   max,i,n) {
  split("",a3,"")
  n = length(a1)
  for(i=1;i<=n;i++) a3[++max] = a1[i]
  n = length(a2)
  for(i=1;i<=n;i++) a3[++max] = a2[i]
  return max
}
function o(l,prefix,order,   indent,   old,i) {
  if(! isarray(l)) {
    print "not array",prefix,l
    return 0}
  if(!order)
    for(i in l) { 
      if (isnum(i))
        order = "@ind_num_asc" 
      else 
        order = "@ind_str_asc"
      break
    }     
   old = PROCINFO["sorted_in"] 
   PROCINFO["sorted_in"]= order
   for(i in l) 
     if (isarray(l[i])) {
       print indent prefix "[" i "]"
       o(l[i],"",order, indent "|   ")
     } else
       print indent prefix "["i"] = (" l[i] ")"
   PROCINFO["sorted_in"]  = old 
}

function rowprint(a,   max,j,str,sep) {
  max = length(a)
  for(j=1;j<=max;j++) {
    str = str sep a[j] 
    sep = ","
  }
  return str
}
function bars(n) {
  return nchars(n,"|-- ")
}
function nchars(n,c,    out) {
  while(n> 0) { n--; out = out c }
  return out
}
function malign() {
  return "gawk -f malign.awk # " rand()
}
function wme(  _Table){
    oo(name,"name"); #oo(score,"score"); 
    #oo(klass,"klass")
    oo(num,"num");   oo(term,"term");   oo(nump,"nump")
    oo(hi,"hi");     oo(lo,"lo");       #oo(s,"s");
    #oo(s2,"s2");     
    oo(n,"n");         oo(most,"most")
    oo(mode,"mode"); oo(most, "most")
}
 function anyi(lst) {
  return int(rand()*length(lst)) + 1
}
