@include "reader.awk"

function tableprint(_Table,stats,   com,max,i,c,row) {
  print ""
  com = malign()
  print rowprint(name)   | com 
  if (stats) {
    centroid(_Table,row)
    print "# "rowprint(row) | com
    for(c in name)
      row[c] = c in nump ? sd[c] : int(100* (1 - most[c]/n[c]))
    print "# " rowprint(row) | com
    }
  max =length(data)
  for(i=1;i<=max;i++)
    print rowprint(data[i])  | com
  close(com)
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
