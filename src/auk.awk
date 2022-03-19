# vim: nospell filetype=awk ts=2 sw=2 sts=2  et :
#--------- --------- --------- --------- --------- ---------

BEGIN{ DOT=sprintf("%c",46)}

function gold2awk(f,  klass,a) {
  while ((getline line <f) >0) {
    # multi line comments delimited with #< ... >#
    if(/^#</) {do {print "# " line} while((getline<f) && (! /^#>/));  print line}
    # grab class name so we can expand "_" to current class
    if (/^func(tion)?[ \t]+[A-Z][^\(]*\(/) {split(line,a,/[ \t\(]/);klass=a[2]}
    gsub(/[ \t]_/," " klass) # expand " _" to the current class
    # a.b.c[1] ==> a["b"]["c"][2]
    print gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/,"[\"\\1\\2\"]","g", line)}}

function new(i) { split("",i,"") }
function Object(i)   { new(i); i["is"]="Object"; i["oid"] = ++OID }

function is(f,got,want,    pre) {
  if (want == "") want=1
  if (want == got) {pre="#TEST:\tPASSED"} else {pre="#TEST:\tFAILED"}
  print( pre "\t" f "\t" want "\t" got ) }

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "Global " s
  for(s in SYMTAB) if (s ~ /^[_a-z]/) print "Rogue: " s }

function has(lst,key,fun) {
  lst[key][SUBSEP]
  split("",lst[key],"")
  if (fun) @fun(lst[key])}

function haS( a,k,f,b)       { has(a,k); @f(a[k],b) }
function hAS(a,k,f,b,c)      { has(a,k); @f(a[k],b,c) }
function HAS(a,k,f,b,c,d)    { has(a,k); @f(a[k],b,c,d) }
function HASS(a,k,f,b,c,d,e) { has(a,k); @f(a[k],b,c,d,e) }

function more(i,f)           { return has(i,length(i)+1,f) }
function morE(i,f,x)         { return haS(i,length(i)+1,f,x) }
function moRE(i,f,x,y)       { return hAS(i,length(i)+1,f,x,y) }
function mORE(i,f,x,y,z)     { return HAS(i,length(i)+1,f,x,y,z) }
function MORE(i,f,w,x,y,z)   { return HASS(i,length(i)+1,f,w,x,y,z) }

function fyi(x) { print x >> "/dev/stderr" }
function warning(txt) { print "#E> " txt > "/dev/stderr" }
function error(txt)   { warning(txt); fflush("/dev/stderr");  exit 1 }

function tests(what, all,   one,a,i,n) {
   n = split(all,a,",")
   print " "
   print "#--- " what " -----------------------"
   for(i=1;i<=n;i++) {
     one = a[i]
     @one(one) }
   rogues() }

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p DOT)
  ooSortOrder(x)
  for(i in x)  {
    if (isarray(x[i]))   {
      print(txt i"" )
      oo(x[i],"","|  " pre)
    } else
      print(txt i (x[i]==""?"": ": " x[i])) }
}
function ooSortOrder(x, i) {
  for (i in x)
    return PROCINFO["sorted_in"] =\
      typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}

