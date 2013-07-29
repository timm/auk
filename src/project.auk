BEGIN { FS=OFS=","}  

@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

function poles(z,_Table,  i,l,r) {
  i = anyi(data) 
  l = furthest(i,z,_Table)
  r = furthest(l,z,_Table)
  pole(l,r,z, _Table)
}
function pole(l,r,z,_Table,    a,b,c,d,all,at) {
  printf("+")
  c = apart(l,r,z,_Table)
  for(d in data[z]) {
    a = apart(d,l,z,_Table)
    b = apart(d,r,z,_Table)
    if (b > c) return pole(l,d)
    if (a > c) return pole(d,r)
    printf("=")
    all++
    at[all]["d"] = d
    at[all]["x"] = (a^2 + c^2 - b^2) / (2*c) ;
    at[all]["y"] = (a^2 - x^2)^0.5   
  }
  max=asort(at,xs,"xsort")
  print ""
  for(i=1;i<=max;i++) {
    d = xs[i]["d"]
    print rowprint(d,_Table[z]),
      xs[i]["x"],xs[i]["y"] | "column -s, -t "
}}
