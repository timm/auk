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
function new2d(a,b)   { a[b][""]; delete a[b] }
function new3d(a,b,c) { a[b][c][""];  delete a[b][c] }
function new(a) {
  split("",a,"")
}
function isnum(x) { 
  return x=="" ? 0 : x == (0+strtonum(x)) 
}
function o(l,prefix,order,   indent,   old,i) {
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



function wme(  _Table){
    oo(name,"name"); #oo(score,"score"); 
    oo(klass,"klass")
    oo(num,"num");   oo(term,"term");   oo(nump,"nump")
    oo(hi,"hi");     oo(lo,"lo");       #oo(s,"s");
    #oo(s2,"s2");     
    oo(n,"n");         oo(most,"most")
    oo(mode,"mode"); oo(most, "most")
}
 function anyi(lst) {
  return int(rand()*length(lst)) + 1
}
