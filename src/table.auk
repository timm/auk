@include "reader.awk"

function klasses(z,_Table,seen,   d) {
  for (d in data[z]) 
    klasses1(d,z,_Table,seen)
}
function klasses1(d,z,_Table,seen,    this) {
  this = klass1(d,_Table[z])
  if (! (this in seen)) {
    seen[this]
    makeTable(name[z],this,_Table)
  }
  addRow(data[z][d],_Table[this])
}
function klass1(d,_Table,    k) {
  for(k in klass)
    return data[d][k]
}
function klassAt(_Table,   k,t) {
  for(t in klass)
    for(k in klass[t])
      return k
}
function tableprint(_Table,stats,   com,max,i,c,row,old) {
  print ""
  old=CONVFMT
  CONVFMT = stats ? stats : "%.6f"
  com = malign()
  print rowprint(name) ", #     notes"   | com 
  if (stats) {
    centroid(_Table,row)
    print "# "rowprint(row)", #  expected" | com
    for(c in name)
      row[c] = c in nump ? sd[c] : most[c]/n[c]
    print "# " rowprint(row) ", # certainty" | com
    }
  max =length(data)
  for(i=1;i<=max;i++)
    print rowprint(data[i]) ", #"  | com
  close(com) 
  CONVFMT=old
}
function centroid(_Table,out,   c) {
  new(out)
  for(c in name)
    out[c] =  c in nump ? mu[c] : mode[c]
}
function expected(what,_Table,    c) {
  for(c in name)
    if (name[c] == what)
      return c in nump ? mu[c] : mode [c]
}
function _table(     _Table,   seen,x,f,a){
  o(ARGV,"argv")
  args("-d,data/weather.csv,-s,1",a)
  
  o(a,"a")
  print a["-d"]
  readcsv(a["-d"], 0, _Table)
  klasses(0,_Table)
  f="%4.2f"
  tableprint(_Table[0],f)
}
